*** Variables ***
${LOGIN_EMAIL_INPUT}            css=[data-testid="email"]
${LOGIN_PASSWORD_INPUT}         css=[data-testid="senha"]
${LOGIN_BUTTON}                 css=[data-testid="entrar"]
${GO_TO_REGISTER_BUTTON}        css=[data-testid="cadastrar"]
${ALERT_MESSAGE}                css=.alert
${ALERT_MESSAGE_TEXT}           css=.alert > span:not([aria-hidden="true"])
${WELCOME_MESSAGE}              xpath=//*[contains(text(), "Bem Vindo")]
${EMAIL_REQUIRED_MESSAGE}       xpath=//div[contains(@class,'alert')]//span[normalize-space()='Email é obrigatório']
${PASSWORD_REQUIRED_MESSAGE}    xpath=//div[contains(@class,'alert')]//span[normalize-space()='Password é obrigatório']