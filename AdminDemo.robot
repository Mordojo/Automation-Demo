*** Settings ***
Library    SeleniumLibrary        
Library    OperatingSystem    
Library    String
Library    Dialogs
Library    REST
# Library    JSONLibrary
Suite Setup    Set Locators From Json    AdminElements.json    
Test Setup    Open JMap Admin    ${URLAdmin}
Test Teardown    Close Browser                           


*** Variables ***
# Robot --listener allure_robotframework;/set/your/path/here ./my_robot_test
# Robot AutomationDemo && robotmetrics
# For github Actions: robot --variable ENV:pp --variable LANG:fr --variable BROWSER:Chrome AdminDemo.robot
${ENV}    ta
${LANG}    en
${BROWSER}    Chrome
${URLAdmin}    http://54.39.78.142:8080
${USERNAME}    demo
${PASSWORD}    demo
${AdminElement}    ${EMPTY}
${CHROME_DRIVER_PATH}    ${CURDIR}${/}BrowsersDriver${/}chromedriver.exe   

*** Test Cases ***
Test Github actions
    Log    \n-----> Actual ENV: ${ENV}    console=yes
    Log    -----> Actual BROWSER: ${BROWSER}    console=yes
    Log    -----> Actual LANG: ${LANG}    console=yes

Login_with_valid_credentials
    Login With Creddentials    ${USERNAME}    ${PASSWORD}
    Verify That The Initial Page Is    Status
    Logout From JMap Admin
    
#Test
    #${json}    Load JSON From File    ${CURDIR}${/}Files${/}AdminElements.json
    #${json}    Get Value From Json    ${json}    $.Username 
    

*** Keywords ***
Open Chrome
    ${chrome options} =     Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium, selenium.webdriver
    Call Method    ${chrome_options}   add_argument    headless
    Call Method    ${chrome_options}   add_argument    --no-sandbox   # newly added argument
    Call Method    ${chrome_options}   add_argument    disable-gpu
    Call Method    ${chrome_options}   add_argument    --ignore-certificate-errors
    ${var}=     Call Method     ${chrome_options}    to_capabilities 
    Create Webdriver   driver_name=Chrome   alias=google   chrome_options=${chrome_options}    #executable_path=${CHROME_DRIVER_PATH}     
    Go To   ${URLAdmin}
    Maximize Browser Window

Set Locators From Json    [Arguments]    ${pJsonFile}   
    ${readJson}    Get File    ${CURDIR}${/}Files${/}${pJsonFile} 
    ${AdminElement}=    Evaluate    json.loads('''${readJson}''')    json
    Set Suite Variable    ${AdminElement}        
            
Open JMap Admin    [Arguments]    ${url}
    Run Keyword If    '${BROWSER}'=='Chrome'    Open Chrome
    
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
