# Robot Framework Automation

Automated testing project using **Robot Framework**, **SeleniumLibrary** and **RequestsLibrary**, covering both frontend UI and backend API scenarios for the [ServeRest](https://serverest.dev/) application.

The project was created to demonstrate practical QA automation skills, including UI automation, API testing, test data generation, JSON Schema validation, reusable keywords, test organization and browser execution strategies.

## 🚀 Technologies

- Python
- Robot Framework
- SeleniumLibrary
- RequestsLibrary
- FakerLibrary
- JSONLibrary
- Chrome / ChromeDriver
- ServeRest API
- ServeRest Frontend

## 📋 Test Coverage

The project currently contains automated scenarios for:

### API Tests

#### Login
- Successful login
- Invalid credentials
- Empty required fields

#### Users
- Create user successfully
- Create user with an existing email
- Create user with empty required fields
- Get user by ID
- Get all users
- Get nonexistent user
- Update user successfully
- Update user with an existing email
- Delete user
- Get user after deletion

#### Products
- Create product successfully
- Create product with an existing name
- Create product with invalid token
- Get all products
- Get product by ID
- Get nonexistent product
- Delete product successfully
- Delete product associated with a cart
- Delete product with invalid token
- Update product successfully
- Update product with an existing name
- Update product with invalid token

### UI Tests

#### Login
- Successful login
- Login with invalid credentials
- Login with empty required fields

#### Users
- Register user successfully
- Register user with an existing email
- Register user with empty required fields

#### Products
- Register product successfully
- Register product with empty required fields
- Register product with an existing name
- Verify registered product in the product list

## 🏗️ Project Structure

```text
robot-framework-automation/
│
├── resources/
│   ├── keywords/
│   │   ├── api_keywords.robot
│   │   └── ui_keywords.robot
│   │
│   ├── variables/
│   │   ├── api_variables.robot
│   │   └── ui_variables.robot
│   │
│   ├── locators/
│   │   ├── login_locators.robot
│   │   ├── register_locators.robot
│   │   └── product_locators.robot
│   │
│   ├── schemas/
│   │   ├── login/
│   │   ├── users/
│   │   └── products/
│   │
│   └── files/
│       └── product.png
│
├── tests/
│   ├── api/
│   │   ├── login.robot
│   │   ├── users.robot
│   │   └── products.robot
│   │
│   └── ui/
│       ├── login.robot
│       ├── users.robot
│       └── products.robot
│
├── .gitignore
├── README.md
└── requirements.txt
```

## 🧩 Project Architecture

The project follows a reusable and organized structure:

### Tests

Contains the test scenarios grouped by application layer:

- `tests/api` — API test scenarios
- `tests/ui` — frontend/UI test scenarios

### Keywords

Reusable actions are centralized in:

```text
resources/keywords/
```

Examples include:

- Login
- Create user
- Create product
- Get product
- Delete product
- Fill forms
- Submit forms
- Validate responses
- Validate UI messages

This reduces duplication and keeps test cases focused on the scenario being validated.

### Locators

UI selectors are separated from the test logic:

```text
resources/locators/
```

This makes locator maintenance easier when the application UI changes.

### Variables

Application URLs and other reusable configuration values are maintained separately:

```text
resources/variables/
```

### Schemas

JSON Schemas are used to validate API response structures:

```text
resources/schemas/
```

This provides structural validation in addition to status code and business-rule assertions.

## 🔐 Test Data

The project uses **FakerLibrary** to generate dynamic test data.

For example:

- User names
- Email addresses
- Passwords
- Product names
- Product descriptions
- Prices
- Quantities

This avoids relying on hardcoded data and reduces conflicts between test executions.

## 🔄 API + UI Integration

Some UI scenarios use the API to prepare their test data.

For example, the duplicate product name scenario follows this flow:

```text
Create administrator
        ↓
Authenticate
        ↓
Create product through API
        ↓
Open product registration through UI
        ↓
Use the same product name
        ↓
Submit registration
        ↓
Validate duplicate-name message
```

This approach keeps UI tests focused on the behavior being validated while using the API for efficient test data setup.

## 🔑 Authentication

The product UI test suite uses a shared authentication session.

The suite setup:

1. Creates an administrator.
2. Authenticates through the API.
3. Stores the API token for data preparation.
4. Opens the browser.
5. Authenticates through the UI.
6. Reuses the authenticated browser session across the product tests.

This avoids performing a new UI login before every test.

## 🏷️ Test Tags

Tests are organized using Robot Framework tags.

Examples:

```text
api
ui
login
users
products
smoke
regression
```

Example:

```robot
[Tags]    ui    products    smoke    regression
```

This allows specific groups of tests to be executed independently.

## ⏱️ Synchronization

The project uses SeleniumLibrary explicit waits instead of fixed delays whenever possible.

For example:

```robot
Wait Until Element Is Visible    ${PRODUCT_NAME_EXISTS_MESSAGE}
```

This makes the tests more reliable and avoids unnecessary `Sleep` statements.

## 🖥️ Browser Execution

UI tests can be executed in normal or headless mode.

### Normal browser

```bash
robot -d results tests/
```

### Headless browser

```bash
robot -d results -v HEADLESS:true tests/
```

The `${HEADLESS}` variable can be controlled directly from the command line, allowing the same test code to be used for local development and CI environments.

## ▶️ Running the Tests

### Install dependencies

Create and activate a Python virtual environment:

```bash
python -m venv .venv
```

Windows:

```bash
.venv\Scripts\activate
```

Install the project dependencies:

```bash
pip install -r requirements.txt
```

### Run all tests

```bash
robot -d results tests/
```

### Run API tests

```bash
robot -d results tests/api/
```

### Run UI tests

```bash
robot -d results tests/ui/
```

### Run a specific test suite

```bash
robot -d results tests/ui/products.robot
```

### Run tests by tag

Run all tests with the `smoke` tag:

```bash
robot -d results -i smoke tests/
```

Run all tests with the `regression` tag:

```bash
robot -d results -i regression tests/
```

### Run all tests in headless mode

```bash
robot -d results -v HEADLESS:true tests/
```

### Run tagged tests in headless mode

```bash
robot -d results -v HEADLESS:true -i smoke tests/ui/
```

## 📊 Test Results

Robot Framework generates execution reports in the `results` directory:

```text
results/
├── log.html
├── report.html
└── output.xml
```

Screenshots generated by SeleniumLibrary when UI tests fail are also stored with the execution results.

The `results/` directory is excluded from version control because these files are generated artifacts.

## 🧪 Validation Strategy

API tests validate responses using multiple levels of assertions:

1. HTTP status code
2. JSON response
3. Expected response structure
4. Required messages
5. JSON Schema
6. Specific business rules

For UI tests, validation includes:

- URL
- Element visibility
- Element text
- Success messages
- Error messages
- Application behavior after user actions

## 🎯 Purpose

This project demonstrates a practical approach to building an automated testing framework with Robot Framework, focusing on:

- Maintainable test automation
- Reusable keywords
- Page/locator separation
- API and UI integration
- Dynamic test data
- JSON Schema validation
- Explicit synchronization
- Smoke and regression test organization
- Headless browser execution
- Test reporting
- CI/CD readiness

## 👨‍💻 Author & Contact

**Vagner Carmo**  
Software QA Analyst | CTFL

- 💼 LinkedIn: [Vagner Carmo](https://www.linkedin.com/in/vagner-do-carmo/)
- 💻 GitHub: [vagner-carmo](https://github.com/vagner-carmo)

---

This project is continuously evolving as new automation scenarios and framework improvements are added.