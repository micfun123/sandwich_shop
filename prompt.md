I have a sandwich shop app written in Flutter. I need your help writing good prompt I can send to an LLM to help me implement a new feature.

I have two pages: an order screen where users can select sandwiches and add them to their cart, and a cart screen where users can see the items in their cart and the total price.

I want to let the users modify the items in their cart. There are different ways a user might want to modify their cart like changing quantity or removing items entirely.

For each of these features, include a clear description and what should happen when the user performs an action. Output the result in a Markdown code block.

```markdown
You are helping implement "modify cart" functionality in a Flutter app (Sandwich Shop). Read and modify the repository as needed. Focus on safe, minimal changes that match existing style. Below are goals, concrete user stories, expected behaviors, suggested file-level changes, UI/UX details, tests, edge cases, and example widgets/code snippets to implement. Follow the acceptance criteria exactly and produce code + unit/widget tests. Ask clarifying questions only if the repository code prevents an obvious, safe change.

Implementation Steps
1. Inspect existing models in `lib/models/` and current cart UI in `lib/views/cart_screen.dart` and `lib/views/order_screen.dart`.
2. Add/update cart APIs in `lib/models/cart.dart` (or repository) to support `updateQuantity(itemId, newQuantity)` and `removeItem(itemId)` and an undo mechanism.
3. Update `lib/views/cart_screen.dart` to allow in-place modification (increment/decrement, direct edit, delete) and show optimistic UI updates + snackbar undo.
4. Add/modify unit & widget tests under `test/` for the new behavior.
5. Run `flutter analyze` and `flutter test`, fix issues.

User Stories & Expected Behaviors (one section per feature)

1) Change quantity via +/- buttons
- Description: Each cart row shows quantity and +/- buttons. Tapping `+` increases quantity by 1. Tapping `-` decreases quantity by 1.
- What should happen:
  - On `+`:
    - If current quantity < `maxQuantity` (use app-level or `OrderScreen` provided limit), increment quantity.
    - Update the cart model/state immediately and update the total price shown on the screen.
    - Persist change through repository (or in-memory model); handle failure by rolling back and showing an error toast/snackbar.
  - On `-`:
    - If quantity > 1, decrement quantity and update cart model & totals immediately.
    - If quantity == 1 and user taps `-`, prompt: either (a) remove item immediately (with snackbar + undo), or (b) open a confirmation dialog before removal. Use option (a) for smooth UX unless explicit confirm needed for destructive actions.
  - Visual + accessibility:
    - Disable `+` when at max, disable or convert `-` to a delete affordance if quantity would become 0.
    - Buttons should have semantic labels for screen readers (e.g., "Increase quantity for BLT").

2) Edit quantity via direct text input
- Description: Users can tap the quantity number to open an inline numeric TextField or dialog to type a number.
- What should happen:
  - Opening the editor focuses numeric keyboard.
  - On submit:
    - If typed value is <= 0 -> treat as remove item (with snackbar + undo).
    - If typed value > `maxQuantity` -> clamp to `maxQuantity` and show a brief message (snackbar) informing the user.
    - Set new quantity, update total immediately, persist change.
  - Cancel reverts to previous quantity.

3) Remove item entirely (trash icon)
- Description: Each row has a trash/delete icon. Tapping removes the item.
- What should happen:
  - Remove the item from cart state instantly (optimistic).
  - Update cart totals and item counts immediately.
  - Show a snackbar: "Removed {Sandwich name}" with "Undo" action. Duration: ~4 seconds.
  - If user taps "Undo", restore the item with previous quantity and totals.
  - If persistence fails (e.g., repository save fails), show an error and restore the item automatically (or prompt retry).

4) Undo removal
- Description: For any removal action (delete button, set quantity to zero), allow quick undo.
- What should happen:
  - Snackbar with "Undo" action appears for 3–5 seconds.
  - If undone, restore previous cart state exactly (quantity, options).
  - If not undone, finalize deletion and ensure persistence layer reflects final state.

5) Update totals & pricing
- Description: Any change to quantity or removal must update visible totals, tax calculations, and discounts.
- What should happen:
  - Immediately recalc and display new subtotal, tax, total.
  - Use existing `repositories/pricing_repository.dart` if present to compute totals; call it after changes.
  - If pricing recalculation fails, show an error and roll back or retry.

File-level guidance (what to change)
- `lib/models/cart.dart`
  - Add / ensure methods: `void updateQuantity(String itemId, int newQuantity)`, `void removeItem(String itemId)`, `void restoreItem(CartItem item)`.
  - If cart is immutable, implement returns/new copies and notify listeners.
  - Provide a minimal undo buffer storing last-removed item + index + timestamp.
- `lib/views/cart_screen.dart`
  - Replace static quantity display with `CartItemRow` widget that shows:
    - `IconButton` decrease, `Text` (or TextField) showing quantity, `IconButton` increase, `IconButton` delete.
  - Implement optimistic state updates and show `SnackBar` with `Undo`.
  - Recompute totals and call pricing repository on change.
- `lib/views/order_screen.dart`
  - Ensure that `maxQuantity` is available to the cart screen or cart model. If not, pass a `maxQuantity` prop or expose a `CartSettings` singleton.
- `lib/repositories/pricing_repository.dart`
  - Ensure there's a public method to compute totals from the cart model: `Pricing computeTotals(Cart cart)` or similar.
- Tests
  - `test/models/cart_test.dart`:
    - Tests for `updateQuantity`, `removeItem`, `restoreItem`.
  - `test/views/cart_screen_test.dart`:
    - Widget tests that simulate tapping `+`, `-`, typing quantity, tapping delete, and pressing `Undo` in snackbar.
    - Verify UI updates (quantity text, subtotal) and that the undo restores previous state.
  - `test/repositories/pricing_repository_test.dart`:
    - Add scenario to validate totals update when quantities change.

Edge cases & error handling
- When new quantity exceeds `maxQuantity`, clamp and inform user.
- When new quantity is negative or 0, treat as removal.
- When persistence errors occur, rollback optimistic UI change and show error.
- Avoid race conditions if user taps rapidly: queue or debounce updates to persistence; allow UI to remain responsive.
- Avoid duplicate undo stacks: only keep one-level undo per row removal (or a simple global last-action undo).
- Accessibility: buttons with semantic labels, large tap targets, consider long-press for quick increment/decrement.

Example UI code snippets (to implement/adapt)

- CartItemRow widget (concept)
```dart
class CartItemRow extends StatelessWidget {
  final CartItem item;
  final int maxQuantity;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(...),
      title: Text(item.name),
      subtitle: Text('\$${item.unitPrice.toStringAsFixed(2)} each'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => onQuantityChanged(max(0, item.quantity - 1)),
            tooltip: 'Decrease quantity',
          ),
          GestureDetector(
            onTap: () => _showQuantityEditor(context, item.quantity),
            child: Text('${item.quantity}', style: TextStyle(fontSize: 16)),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: item.quantity >= maxQuantity ? null : () => onQuantityChanged(item.quantity + 1),
            tooltip: 'Increase quantity',
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onRemove,
            tooltip: 'Remove item',
          ),
        ],
      ),
    );
  }
}
```