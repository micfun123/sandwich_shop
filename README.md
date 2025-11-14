# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.
The app is built using Flutter and Dart, and it is designed primarily to be run in a web
browser.

## Features

- Easy web UI for ordering sandwiches in two sizes: six-inch and footlong.
- Toggle sandwich size and choose toasted or untoasted.
- Choose bread type: `white`, `wheat`, or `wholemeal`.
- Add a custom order note (e.g., "no onions").
- Enforces a per-order limit (configurable; default 5 sandwiches).
- Price calculation in GBP: six-inch £7, footlong £11 (calculated and displayed).
- Pricing logic covered by unit tests.


This project lets the user purchase sandwiches in the sizes of 6-inch and footlong. The user can also leave a comment with their order. Users are limited to ordering a maximum of 5 sandwiches at a time.


# Installation and Setup Instructions

## Install the essential tools

1. **Terminal**:

    - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
    - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`, in the terminal.
    If this is missing, download the installer from [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).

3. **Package managers**:

    - **Homebrew** (macOS) – verify that you have `brew` installed with `brew --version`; if missing, follow the instructions on the [Homebrew installation page](https://brew.sh/).
    - **Chocolatey** (Windows) – verify that you have `choco` installed with `choco --version`; if missing, follow the instructions on the [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is working with `flutter doctor`; if missing, install it using your package manager:

    - **macOS**: `brew install --cask flutter`
    - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with `code --version`; if missing, use your package manager to install it:

    - **macOS**: `brew install --cask visual-studio-code`
    - **Windows**: `choco install vscode`

## Usage Instructions
1. **Clone the repository**:
    ```bash
    git clone https://github.com/micfun123/sandwich_shop.git
    cd sandwich_shop
    ```
2. **Get the dependencies**:
    ```bash
    flutter pub get
    ```
3. **Run the app**:
    ```bash
    flutter run -d chrome
    ```

4. **tests**:
    To run the tests for this project, use the following command:
    ```bash
    flutter test
    ```
    

## Contact Me
If you have any questions or need further assistance, feel free to reach out!
- **Email**:
    - up2263259@myport.ac.uk
- **GitHub**:
    - [github.com/micfun123](https://github.com/micfun123)


