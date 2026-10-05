*** Settings ***
Resource    ../../resources/keywords/api_keywords.robot
Resource    ../../resources/keywords/ui_keywords.robot

Suite Setup       Open Product Test Session
Suite Teardown    Close All Browsers

*** Test Cases ***
User Should Be Able To Register A Product Successfully
    [Documentation]    Verifies that an administrator can register a product using all available product fields.
    [Tags]    ui    products    smoke    regression

    ${product}=    Create Random Product Data

    Open Product Registration Page

    Fill Product Registration Form
    ...    ${product}[name]
    ...    ${product}[price]
    ...    ${product}[description]
    ...    ${product}[quantity]
    ...    ${EXECDIR}/resources/files/product.png

    Submit Product Registration
    
    Verify Product Is Listed    ${product}[name]

User Should Not Be Able To Register A Product With Empty Fields
    [Documentation]    Verifies that a product cannot be registered when all required fields are empty.
    [Tags]    ui    products    regression

    Open Product Registration Page

    Submit Product Registration

    Verify Empty Product Fields

User Should Not Be Able To Register A Product With Existing Name
    [Documentation]    Verifies that a product cannot be registered when another product with the same name already exists.
    [Tags]    ui    products    regression

    ${product}    ${product_response}=    Create Random Product    ${API_TOKEN}

    Status Should Be    201    ${product_response}

    Open Product Registration Page

    Fill Product Registration Form
    ...    ${product}[name]
    ...    ${product}[price]
    ...    ${product}[description]
    ...    ${product}[quantity]
    ...    ${EXECDIR}/resources/files/product.png

    Submit Product Registration

    Verify Product Name Already Exists