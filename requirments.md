**Feature Overview**
- **Title**: Modify Cart Items (Quantity Editing, Removal, Undo)
- **Purpose**: Allow users to modify items already added to their cart on the Cart screen — change item quantities (via +/- or direct edit), remove items, and undo removals — while keeping totals, pricing, and persistence consistent, responsive, and accessible.
- **Scope**: UI and model changes necessary for in-cart editing and removal, optimistic updates with undo, persistence hooks to the repository, and unit/widget tests. Files in scope include `lib/models/cart.dart`, `lib/views/cart_screen.dart`, `lib/views/order_screen.dart`, `lib/repositories/pricing_repository.dart`, and tests under `test/`.

**Motivation & Value**
- Reduces friction for customers adjusting orders before checkout.
- Improves conversion by making corrections and quantity changes fast and recoverable.
- Keeps cart totals accurate and consistent across screens.

**User Roles**
- **End User**: Regular shopper adding, adjusting, or removing sandwiches before checkout.
- **Power User**: Quickly adjusts many items (rapid taps) and expects responsive UI.
- **Accessibility User**: Relies on screen readers and accessible affordances.
- **Tester / Developer**: Verifies model behavior, persistence, and UI via unit & widget tests.

**User Stories**
- **Story 1 — Increase quantity (basic)**  
  - As an End User, I want to tap a `+` button on a cart item to increase its quantity by 1 so that I can order more of that sandwich.
  - Success: Quantity increments immediately, subtotal/total update immediately, `+` is disabled at `maxQuantity`, change persists in repository.

- **Story 2 — Decrease quantity (basic → removal)**  
  - As an End User, I want to tap a `-` button to decrease quantity so that I can order fewer sandwiches.
  - Success: If quantity > 1, it decrements and totals update immediately. If quantity == 1 and I press `-`, the item is removed (optimistically) and I see a snackbar with "Undo".

- **Story 3 — Direct edit quantity (precise edits)**  
  - As an End User, I want to tap the displayed quantity to type a number so I can set an exact quantity quickly.
  - Success: Tapping opens numeric editor (inline or dialog). On submit, values <= 0 remove the item (snackbar + Undo), values > `maxQuantity` are clamped and user informed (snackbar). Totals update instantly; persistence attempted.

- **Story 4 — Remove item (explicit delete)**  
  - As an End User, I want to tap a trash icon to remove an item so I can delete items quickly.
  - Success: Item removed optimistically, totals update instantly, snackbar shows "Removed {name}" with "Undo". If persistence fails, error shown and item restored.

- **Story 5 — Undo removal**  
  - As an End User, I want a short window to undo a removal so I can recover accidental deletes.
  - Success: Snackbar with "Undo" available 3–5 seconds. If tapped, the item and its quantity/options are restored exactly.

- **Story 6 — Accurate pricing and totals**  
  - As an End User, I want the subtotal/tax/total to reflect any cart modification immediately so I can trust the displayed price.
  - Success: Totals recomputed immediately using `pricing_repository` or equivalent; UI updates to show new subtotal/tax/total.

- **Story 7 — Resilient to rapid interactions**  
  - As a Power User, I expect the app to remain responsive if I tap +/− repeatedly.
  - Success: UI updates optimistically, repository updates are queued/debounced to avoid conflicts, final persisted state matches last user action.

- **Story 8 — Accessible controls**  
  - As an Accessibility User, I want all controls to have accessible labels and large hit targets.
  - Success: Buttons have semantic labels (e.g., "Increase quantity for BLT"), keyboard input focus works, and VoiceOver/ TalkBack reads appropriate messages.

**Acceptance Criteria**
- **Functional**
  - - **Quantity Buttons**: Tapping `+` increments quantity by 1 (unless at `maxQuantity`), tapping `-` decrements by 1 (removes if becomes 0). UI updates immediately.
  - - **Direct Edit**: Tapping quantity opens numeric editor; submit updates or removes item according to the rules; cancel reverts changes.
  - - **Delete**: Tapping delete icon removes item optimistically, updates totals immediately.
  - - **Undo**: Any removal shows a snackbar with "Undo". If pressed within 3–5s, cart returns to pre-removal state exactly.
  - - **Totals**: Subtotal, tax and final total recalc and display immediately after any change.
  - - **Persistence**: All updates call the repository layer to persist changes. Failures must be detected and handled (rollback + error message).
- **Non-functional**
  - - **Performance**: UI updates must feel instantaneous (<100ms perceptible). Repository calls may be asynchronous; queue/debounce to avoid conflicts during rapid taps.
  - - **Reliability**: Only one-level undo required (last removal). No inconsistent duplicate-restore states after undo or network errors.
  - - **Accessibility**: All interactive controls include semantic labels; numeric editor uses numeric keyboard where applicable.
  - - **Test Coverage**: Unit tests for model APIs and widget tests for interactive flows (increase, decrease, direct edit, delete + undo).
- **Edge-case Behavior**
  - - **Exceeding `maxQuantity`**: When user attempts to set > `maxQuantity`, clamp to `maxQuantity` and show an informational snackbar.
  - - **Zero / Negative Input**: Treat as removal (show snackbar + Undo).
  - - **Persistence Failure**: On repository failure, show a persistent error Snackbar with "Retry" and restore optimistic change immediately if retry fails.
  - - **Rapid Changes**: Last user intention wins — final persisted cart matches last action after debounced updates.

**Success Criteria (how product owner will verify)**
- - Run `flutter analyze` → no new analyzer errors.
- - Unit tests under `test/models/` validate `updateQuantity`, `removeItem`, `restoreItem`.
- - Widget tests under `test/views/` simulate tap sequences: `+`, `-`, type quantity, delete + undo; tests pass and assert UI totals change appropriately.
- - Manual test checklist passes: increment, decrement, delete + undo, direct edit clamp/remove, and persistence behavior when repository simulated to fail.

**Design & UX Requirements**
- **Cart Row Layout**
  - - **Left**: Thumbnail + item name and unit price.
  - - **Right**: Horizontal controls [−] [quantity (tap to edit)] [+] [trash icon].
  - - **Disabled States**: `+` disabled at `maxQuantity`; `-` becomes delete affordance only if quantity is 1 (or still acts normally but deletes).
  - - **Snackbars**: Use `ScaffoldMessenger` to show removal messages with `SnackBarAction(label: 'Undo')`.
- **Flows**
  - - **Optimistic Update Flow**: Update UI immediately → queue persistence → on success keep state → on failure restore & show error.
  - - **Undo Flow**: Removal action pushes last-removed item to an undo buffer (item + index). If Undo pressed, restore exactly and cancel backend removal; otherwise finalize removal after snackbar duration.
- **Accessibility**
  - - Buttons must have `tooltip` and semantics describing the action and item name.
  - - Numeric editor must use `keyboardType: TextInputType.number` and proper focus behavior.

**Implementation Subtasks**
- **Subtask 1 — Model APIs**
  - - **File**: `lib/models/cart.dart`  
  - - **Work**: Add/ensure methods `updateQuantity(String itemId, int newQuantity)`, `removeItem(String itemId)`, `restoreItem(CartItem item)` and an undo buffer (last-removed item + index + timestamp). Ensure listeners/notifications are fired (e.g., `notifyListeners()` if using `ChangeNotifier`).
  - - **Acceptance**: Unit tests confirm model returns correct state after update/remove/restore.

- **Subtask 2 — Cart UI & Interaction**
  - - **File**: `lib/views/cart_screen.dart`  
  - - **Work**: Replace static quantity display with `CartItemRow` widget containing `IconButton` decrease, quantity `Text` (tap to edit), `IconButton` increase, and `IconButton` delete. Implement optimistic updates and snackbar undo behavior.
  - - **Acceptance**: Widget tests for tapping `+`, `-`, typing quantity, delete + undo succeed and UI totals update.

- **Subtask 3 — Order Screen Integration**
  - - **File**: `lib/views/order_screen.dart`  
  - - **Work**: Ensure `maxQuantity` is available to the cart screen or model (pass in as prop if needed).
  - - **Acceptance**: Increasing quantity respects `maxQuantity`.

- **Subtask 4 — Pricing Integration**
  - - **File**: `lib/repositories/pricing_repository.dart`  
  - - **Work**: Provide/ensure a method to compute totals from cart (e.g., `Pricing computeTotals(Cart cart)`), called whenever cart changes.
  - - **Acceptance**: Totals displayed reflect repository output in both model and UI tests.

- **Subtask 5 — Tests**
  - - **Files**: `test/models/cart_test.dart`, `test/views/cart_screen_test.dart`, `test/repositories/pricing_repository_test.dart`  
  - - **Work**: Add unit tests for model APIs and widget tests simulating user interactions; include failure/rollback and undo scenarios.
  - - **Acceptance**: `flutter test` passes for the new tests and existing ones.

- **Subtask 6 — Error Handling & Edge Cases**
  - - **Work**: Implement clamping to `maxQuantity`, negative/zero handling as removal, queue/debounce persistence, and error rollback with retry option.
  - - **Acceptance**: Tests cover clamping and persistence failure flows.

- **Subtask 7 — QA & Accessibility**
  - - **Work**: Verify semantic labels, keyboard navigation, and VoiceOver/TalkBack behavior. Update `lib/views/app_styles.dart` if style/tap targets adjustments needed.
  - - **Acceptance**: Manual accessibility checks complete; tool-based checks (if available) pass.

**Test Cases (concrete)**
- **TC1 — Increment quantity**
  - - Precondition: Item quantity = 1, maxQuantity = 5.  
  - - Action: Tap `+`.  
  - - Expected: Quantity becomes 2, subtotal updated, repository update scheduled/called.

- **TC2 — Decrement to removal**
  - - Precondition: Item quantity = 1.  
  - - Action: Tap `-`.  
  - - Expected: Item removed from UI, totals updated, snackbar shows "Undo". On Undo: item restored with quantity 1.

- **TC3 — Direct edit overflow**
  - - Precondition: maxQuantity = 5.  
  - - Action: Edit quantity to 10 and submit.  
  - - Expected: Quantity set to 5, snackbar informs "Quantity limited to 5", totals update.

- **TC4 — Direct edit remove**
  - - Action: Edit quantity to 0 and submit.  
  - - Expected: Item removed, snackbar with Undo appears.

- **TC5 — Persistence failure**
  - - Action: Remove item; backend simulated to fail.  
  - - Expected: Item restored automatically and an error snackbar with Retry action shown.

- **TC6 — Rapid tapping**
  - - Action: Tap `+` 10 times quickly with maxQuantity 20.  
  - - Expected: UI increments up to 11, updates remain responsive, repository calls are debounced; final persisted count matches last UI state.

**Open Questions / Assumptions**
- - **Persistence model**: Assume cart is persisted via repository (`lib/repositories/pricing_repository.dart` or other). If a different persistence mechanism is used in the repo (Provider, Bloc, local DB), integrate with existing pattern rather than introducing a new one.
- - **Undo depth**: Requirement assumes a single-level undo sufficient. If multi-level undo is desired, scope must be expanded.
- - **maxQuantity**: `OrderScreen` currently passes `maxQuantity` (seen in `lib/main.dart`); ensure cart screen can access this value or a shared configuration.

**Delivery Checklist**
- - [X] Implement model changes in `lib/models/cart.dart`.
- - [X] Implement `CartItemRow` and cart screen changes in `lib/views/cart_screen.dart`.
- - [X] Ensure `maxQuantity` accessible from `lib/views/order_screen.dart`.
- - [X] Integrate pricing recalculation using `lib/repositories/pricing_repository.dart`.
- - [X] Add unit and widget tests under `test/`.
- - [X] Run `flutter analyze` and `flutter test` and fix issues.
- - [X] Manual QA: run through test cases and accessibility checks.

**Next Steps (developer guidance)**
- - Start with small focused commits per subtask listed above (one commit per subtask).
- - Write unit tests for model behavior before UI changes (TDD style).
- - Implement optimistic UI updates and snackbar undo in `cart_screen` with clear rollback logic on persistence failure.
- - Share patches if you want me to create concrete diffs for `lib/models/cart.dart` and `lib/views/cart_screen.dart`.