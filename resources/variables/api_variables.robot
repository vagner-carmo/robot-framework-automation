*** Variables ***
${API_BASE_URL}    https://serverest.dev

${LOGIN_SUCCESS_SCHEMA}             ${EXECDIR}/resources/schemas/login/login_success.json
${LOGIN_INVALID_SCHEMA}             ${EXECDIR}/resources/schemas/login/login_invalid_credentials.json
${LOGIN_EMPTY_FIELDS_SCHEMA}        ${EXECDIR}/resources/schemas/login/login_empty_fields.json

${USER_CREATE_SUCCESS_SCHEMA}       ${EXECDIR}/resources/schemas/users/create_success.json
${USER_CREATE_ERROR_SCHEMA}         ${EXECDIR}/resources/schemas/users/create_error.json
${USER_GET_SUCCESS_SCHEMA}          ${EXECDIR}/resources/schemas/users/get_success.json
${USER_GET_ALL_SCHEMA}              ${EXECDIR}/resources/schemas/users/get_all_success.json
${USER_GET_NOT_FOUND_SCHEMA}        ${EXECDIR}/resources/schemas/users/get_not_found.json
${USER_UPDATE_SUCCESS_SCHEMA}       ${EXECDIR}/resources/schemas/users/update_success.json
${USER_DELETE_SUCCESS_SCHEMA}       ${EXECDIR}/resources/schemas/users/delete_success.json
${USER_CREATE_EMPTY_FIELDS_SCHEMA}    ${EXECDIR}/resources/schemas/users/create_empty_fields.json

${PRODUCT_CREATE_SUCCESS_SCHEMA}    ${EXECDIR}/resources/schemas/products/create_success.json
${PRODUCT_CREATE_ERROR_SCHEMA}    ${EXECDIR}/resources/schemas/products/create_error.json
${PRODUCT_CREATE_INVALID_TOKEN_SCHEMA}    ${EXECDIR}/resources/schemas/products/create_invalid_token.json
${PRODUCT_GET_ALL_SCHEMA}    ${EXECDIR}/resources/schemas/products/get_all_success.json
${PRODUCT_GET_SUCCESS_SCHEMA}    ${EXECDIR}/resources/schemas/products/get_success.json
${PRODUCT_GET_NOT_FOUND_SCHEMA}    ${EXECDIR}/resources/schemas/products/get_not_found.json
${PRODUCT_DELETE_SUCCESS_SCHEMA}    ${EXECDIR}/resources/schemas/products/delete_success.json
${PRODUCT_DELETE_INVALID_TOKEN_SCHEMA}    ${EXECDIR}/resources/schemas/products/delete_invalid_token.json
${PRODUCT_DELETE_CART_ERROR_SCHEMA}    ${EXECDIR}/resources/schemas/products/delete_cart_error.json
${PRODUCT_UPDATE_SUCCESS_SCHEMA}    ${EXECDIR}/resources/schemas/products/update_success.json
${PRODUCT_UPDATE_DUPLICATE_NAME_SCHEMA}    ${EXECDIR}/resources/schemas/products/update_duplicate_name.json
${PRODUCT_UPDATE_INVALID_TOKEN_SCHEMA}    ${EXECDIR}/resources/schemas/products/update_invalid_token.json