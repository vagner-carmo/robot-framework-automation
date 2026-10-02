*** Settings ***
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/keywords/ui_keywords.robot

Suite Setup       Open Browser Session
Suite Teardown    Close All Browsers

*** Test Cases ***
User Should Be Able To Register Successfully
    [Documentation]    Verifies that a new user can be successfully registered through the login registration page.
    [Tags]    ui    users    smoke    regression

    ${user}=    Create Random User

    Open Login Page
    Open Registration Page

    Fill Registration Form
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Submit Registration Form
    Verify Successful Registration

User Should Not Be Able To Register With Existing Email
    [Documentation]    Verifies that a user cannot be registered with an email that is already in use.
    [Tags]    ui    users    regression

    ${user}=    Create Random User

    Create User
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Open Login Page
    Open Registration Page

    Fill Registration Form
    ...    ${user}[name]
    ...    ${user}[email]
    ...    ${user}[password]
    ...    ${user}[administrator]

    Submit Registration Form
    Verify Email Already Exists

User Should Not Be Able To Register With Empty Fields
    [Documentation]    Verifies that validation messages are displayed when registration fields are empty.
    [Tags]    ui    users    regression

    Open Login Page
    Open Registration Page

    Fill Registration Form
    ...    ${EMPTY}
    ...    ${EMPTY}
    ...    ${EMPTY}
    ...    ${FALSE}

    Submit Registration Form
    Verify Empty Registration Fields