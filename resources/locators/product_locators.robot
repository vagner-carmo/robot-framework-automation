*** Variables ***
${PRODUCT_REGISTER_NAV}                    css=[data-testid="cadastrar-produtos"]

${PRODUCT_NAME_INPUT}                      css=[data-testid="nome"]
${PRODUCT_PRICE_INPUT}                     css=[data-testid="preco"]
${PRODUCT_DESCRIPTION_INPUT}               css=[data-testid="descricao"]
${PRODUCT_QUANTITY_INPUT}                  css=[data-testid="quantity"]
${PRODUCT_IMAGE_INPUT}                     css=[data-testid="imagem"]
${PRODUCT_REGISTER_BUTTON}                 css=[data-testid="cadastarProdutos"]
${PRODUCT_NAME_REQUIRED_MESSAGE}           xpath=//div[contains(@class,'alert')]//span[normalize-space()='Nome é obrigatório']
${PRODUCT_PRICE_REQUIRED_MESSAGE}          xpath=//div[contains(@class,'alert')]//span[normalize-space()='Preco é obrigatório']
${PRODUCT_DESCRIPTION_REQUIRED_MESSAGE}    xpath=//div[contains(@class,'alert')]//span[normalize-space()='Descricao é obrigatório']
${PRODUCT_QUANTITY_REQUIRED_MESSAGE}       xpath=//div[contains(@class,'alert')]//span[normalize-space()='Quantidade é obrigatório']
${PRODUCT_NAME_EXISTS_MESSAGE}             xpath=//div[contains(@class,'alert')]//span[normalize-space()='Já existe produto com esse nome']