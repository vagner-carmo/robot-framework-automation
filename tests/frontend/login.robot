*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
User Should Be Able To Access Login Page
    Open Browser    https://front.serverest.dev/    chrome
    Maximize Browser Window

    Title Should Be    Front - ServeRest

    Close Browser