*** Settings ***
Library    SeleniumLibrary    run_on_failure=No operation       
Library    OperatingSystem    
Library    String
Library    Dialogs
Library    REST
# Library    JSONLibrary
# Suite Setup    Set Locators From Json    AdminElements.json    
# Test Setup    Open JMap Admin    ${URLAdmin}
# Test Teardown    Close Browser                           


*** Variables ***
# Robot --listener allure_robotframework;/set/your/path/here ./my_robot_test
# Robot AutomationDemo && robotmetrics
# For github Actions: robot --variable ENV:pp --variable LANG:fr --variable BROWSER:Chrome AdminDemo.robot
#                     robot --variable ENV:pp --variable LANG:fr --variable BROWSER:Chrome --include Facebook .
#                     robot --variable ENV:pp --variable LANG:fr --variable BROWSER:Chrome --include Employed .
#                     robot --variable ENV:ta --variable LANG:en --variable BROWSER:Chrome --include JMap .
#                     robot --variable ENV:ta --variable LANG:en --variable BROWSER:Chrome --include USE_TAGE:Transparency .
${ENV}    pp
${LANG}    fr
${BROWSER}    Chrome
#${USE_TAGE}    ${EMPTY}
${NEW_TE}    ${EMPTY}
${USE_JIRA}    ${EMPTY}
${URLAdmin}    http://54.39.78.142:8080
${USERNAME}    demo
${PASSWORD}    demo
${AdminElement}    ${EMPTY}
# ${CHROME_DRIVER_PATH}    ${CURDIR}${/}BrowsersDriver${/}chromedriver.exe   

*** Test Cases ***
Test Github actions
    [Tags]    JMap    Transparency
    Log    \n-----> Actual ENV: ${ENV}    console=yes
    Log    -----> Actual LANG: ${LANG}    console=yes
    Log    -----> Actual BROWSER: ${BROWSER}    console=yes
    Log    -----> Actual TE: ${NEW_TE}    console=yes
    Log    -----> USE JIRA: ${USE_JIRA}    console=yes

Login_with_valid_credentials
    [Tags]    JMap
    Log    \n-----> JMap Test ...    console=yes
    Log    -----> Actual ENV: ${ENV}    console=yes
    Log    -----> Actual LANG: ${LANG}    console=yes
    Log    -----> Actual BROWSER: ${BROWSER}    console=yes
    Log    -----> Actual TE: ${NEW_TE}    console=yes
    Log    -----> USE JIRA: ${USE_JIRA}    console=yes
    # Login With Creddentials    ${USERNAME}    ${PASSWORD}
    # Verify That The Initial Page Is    Status
    # Logout From JMap Admin
    
Open Facbook Test
    [Tags]    Facebook    Transparency
    Log    \n-----> Open Facebook:    console=yes
    Log    -----> Actual ENV: ${ENV}    console=yes
    Log    -----> Actual LANG: ${LANG}    console=yes
    Log    -----> Actual BROWSER: ${BROWSER}    console=yes
    Log    -----> Actual TE: ${NEW_TE}    console=yes
    Log    -----> USE JIRA: ${USE_JIRA}    console=yes
    # Set variables
    &{createNewAccountBtn}    Create Dictionary    en=Create new account    fr=Créer nouveau compte
    &{signUpBtn}    Create Dictionary    en=Sign Up    fr=S’inscrire

    # Open Facebook
    Open Url    https://www.facebook.com
    # Close cookies popup if its appear
    ${isCookiesPopup}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[@data-testid='cookie-policy-manage-dialog-decline-button']    timeout=2s        
    Run Keyword Unless    ${isCookiesPopup}==${False}    Click Button    //button[@data-testid='cookie-policy-manage-dialog-decline-button']  
    # check current language of browser
    Wait Until Element Is Visible    //ul[contains(@class, 'uiList localeSelectorList')]/li   
    ${curSelectedLang}    Get Text    //ul[contains(@class, 'uiList localeSelectorList')]/li[1]
    Run Keyword If    "${LANG}"=="fr" and "${curSelectedLang}"!="Français (France)"    Click Element    //a[contains(text(),"Français")]
    ...    ELSE IF    "${LANG}"=="en" and "${curSelectedLang}"!="English (US)"    Click Element    //a[contains(text(),"English")]
    # Close cookies popup again if its appear
    ${isCookiesPopup}    Run Keyword And Return Status    Wait Until Element Is Enabled    //button[@data-testid='cookie-policy-manage-dialog-decline-button']    timeout=2s        
    Run Keyword Unless    ${isCookiesPopup}==${False}    Click Button    //button[@data-testid='cookie-policy-manage-dialog-decline-button']
    
    Log    \n****** Verifying Buttons contents in "${LANG}" ******    console=yes
    Wait Until Element Is Visible    //a[@data-testid='open-registration-form-button']    timeout=30s       
    ${registrationBtn}    Get Text    //a[@data-testid='open-registration-form-button']
    Log    -----> ${registrationBtn}    console=yes
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${registrationBtn}    ${createNewAccountBtn['${LANG}']}
    Click Element    //a[@data-testid='open-registration-form-button']
    Wait Until Element Is Enabled    //input[@name='firstname'] 
    Wait Until Element Is Enabled    //input[@name='lastname']   
    Input Text    //input[@name='firstname']    Hassen
    Input Text    //input[@name='lastname']    Smoklou
    Click Button    //button[@name='websubmit']
    ${websubmitBtn}    Get Text    //button[@name='websubmit']
    Run Keyword And Continue On Failure    Should Be Equal As Strings    ${websubmitBtn}    ${signUpBtn['${LANG}']}
    Log    -----> ${websubmitBtn}    console=yes
    Sleep    1s  
    Close Browser
    
#Test
    #${json}    Load JSON From File    ${CURDIR}${/}Files${/}AdminElements.json
    #${json}    Get Value From Json    ${json}    $.Username 
    

*** Keywords ***
Open Url    [Arguments]    ${url}
    Run Keyword If    '${BROWSER}'=='Chrome'    Open Chrome
    Go To   ${url}
    #Maximize Browser Window 
    Set Window Size    1920    1080
    #Sleep    1s               
    
Open Chrome
    ${chrome options} =     Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium, selenium.webdriver
    # Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    --no-sandbox   # newly added argument
    Call Method    ${chrome_options}   add_argument    disable-gpu
    Call Method    ${chrome_options}   add_argument    --ignore-certificate-errors
    ${var}=     Call Method     ${chrome_options}    to_capabilities 
    Create Webdriver   driver_name=Chrome   alias=google   chrome_options=${chrome_options}    # executable_path=${CHROME_DRIVER_PATH}

Set Locators From Json    [Arguments]    ${pJsonFile}   
    ${readJson}    Get File    ${CURDIR}${/}Files${/}${pJsonFile} 
    ${AdminElement}=    Evaluate    json.loads('''${readJson}''')    json
    Set Suite Variable    ${AdminElement}        
            
Open JMap Admin    [Arguments]    ${url}
    Run Keyword If    '${BROWSER}'=='Chrome'    Open Chrome
    Go To   ${url}
    Maximize Browser Window
    
Login With Creddentials    [Arguments]    ${pUSERNAME}    ${pPASSWORD}
    Log    ${AdminElement["Username"]}  
    Wait Until Element Is Visible    //div[contains(@class, 'BigTopic')]    
    ${serverName}    Get Text    //div[contains(@class, 'BigTopic')]
    Log    \n-----> Server Name: ${serverName}    console=yes
    Wait Until Element Is Visible    ${AdminElement["Username"]}    7s
    Input Text    ${AdminElement["Username"]}    ${pUSERNAME}
    Input Text    ${AdminElement["Password"]}    ${pPASSWORD}
    Click Button    ${AdminElement["Login"]}    
        
Verify That The Initial Page Is    [Arguments]    ${text}
    Wait Until Element Is Visible    ${AdminElement["StatusPage"]}    7s
    Run Keyword And Continue On Failure    Element Should Contain    ${AdminElement["StatusPage"]}    ${text}
    Wait Until Element Is Visible    //div[contains(@class, 'toolbarTitleStyle')]    
    ${toolbarTitle}    Get Text    //div[contains(@class, 'toolbarTitleStyle')]
    Log    -----> StatusPage: ${toolbarTitle}    console=yes               
       
Logout From JMap Admin
    Wait Until Element Is Visible    ${AdminElement["UserMenu"]}    7s
    Click Element    ${AdminElement["UserMenu"]}    
    Wait Until Element Is Visible    ${AdminElement["Logout"]}    7s   
    Click Element    ${AdminElement["Logout"]}
    Wait Until Element Is Visible    //div[contains(@class, 'BigTopic')]    
    ${serverName}    Get Text    //div[contains(@class, 'BigTopic')]
    Log    -----> Server Name: ${serverName}    console=yes   
	
# Add new Keywords
