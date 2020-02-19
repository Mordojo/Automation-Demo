*** Settings ***
Library    REST    http://dummy.restapiexample.com    accept=application/json   
Library    OperatingSystem    
Library    String
Library    Dialogs      
    
*** Variables ***
${employees}    /api/v1/employees
${employe/id}    /api/v1/employee
${createEmploye}    /api/v1/create

*** Test Cases ***
GET Request 
    Get All Users
    Response Status Code Should Equal    200    
    Get An Existing User    10602
    String    $.employee_salary    2100
    String    $.employee_age    27   

POST RestAPI
    ${body}    Catenate    {"id":"11","name":"Kallouz","salary":"2100","age":"27"}    
    Log    \n${body}    console=yes
    ${object}=    Evaluate    json.loads('''${body}''')    json
    Log    ${object}    console=yes
    log    Hello, my name is "${object["name"]}" and my salary is "${object["salary"]} $"    WARN
    POST    /api/v1/create    ${object}     # OR ${body} the both are correct
    [Teardown]    Output    response body    ${OUTPUTDIR}/new_user.demo.json
    
PUT RestAPI
    Put    /api/v1/update/171461    {"name":"Kechroud007","salary":"1900","age":"35"}

DELETE RestAPI
    Delete    /api/v1/delete/171461    validate=false
    
POST RestAPI From Json File
    Create User(s) From Json    PostEmploye.json
    
TC_01 Create, Update and Delete The User
    Create User(s) From Json    PostUser.json
    Get All Users
    ${ID}    Get Id Of An Existing User From Json    Employees.json
    Get An Existing User    ${ID}
    String    $.employee_name    Smoklou
    String    $.employee_salary    3700
    String    $.employee_age    35
    #Pause Execution        
    Put    /api/v1/update/${ID}    {"name":"SmoklouBFK","salary":"1900","age":"33"}    timeout=3
    Get An Existing User    ${ID}
    String    $.employee_name    SmoklouBFK
    String    $.employee_salary    1900
    String    $.employee_age    33
    #Pause Execution   
    Delete    /api/v1/delete/${ID}

# Shutdown PC
    # Run    shutdown -s -f -t 30
            

*** Keywords ***
Get All Users
    Log    =================================================================================    console=yes
    Log    *** Go to get ALL existing users ***    console=yes
    Get    /api/v1/employees    timeout=1
    [Teardown]    Output    response body    ${CURDIR}/Employees.json 

Get An Existing User
    [Arguments]    ${id}   
    Log    =================================================================================    console=yes
    Log    *** Go to get the existing user : ID=${id} ***    console=yes
    Get    /api/v1/employee/${id}
    Run Keyword And Continue On Failure    String    response body id    ${id}
    [Teardown]    Output    $.id    #${CURDIR}/Employee.json    
    
    
Response Status Code Should Equal
    [Arguments]    ${status}
    
    ${curStatus}    Get Response Status
    log    ${curStatus}    console=yes
    Run Keyword If    '${curStatus}' == '${status}'
    ...    Log    *** The response equals to "${status}". So, as expected ...!!! ***    console=yes
    ...    ELSE
    ...    Log    *** The response not equals to "${status}". But, it was "${curStatus}" ***    WARN
       
    Run Keyword And Continue On Failure    Integer    response status    ${status}    #Asserts the field as JSON integer  
     
Get Response Status
    Log    =================================================================================    console=yes
    ${curStatus}    Integer    response status
    Log    *** Go to get response status ***    console=yes    
    [Return]    ${curStatus[0]}

Get Id Of An Existing User From Json
    [Arguments]    ${jsonFile}
    
    Log    \n=========== Read the file "${jsonFile}" ====================================    console=yes
    ${body}    Get File    ${jsonFile} 
    Log    =========== Evaluate the file "${jsonFile}" to json file" ====================================    console=yes
    ${object}=    Evaluate    json.loads('''${body}''')    json 
    
    ${lenght}    Get Length    ${object}
    Log    =========== Retrieve the ID of the user : "${object[${lenght}-1]}" ====================================    console=yes   
    
    [Return]    ${object[${lenght}-1]["id"]}
      
Create User(s) From Json
    [Arguments]    ${jsonFile}
    
    Log    \n=========== Read the file "${jsonFile}" ====================================    console=yes
    ${body}    Get File    ${jsonFile}
    Log    ${body}    console=yes   
    Log    =========== Evaluate the file "${jsonFile}" to json file" ====================================    console=yes
    ${object}=    Evaluate    json.loads('''${body}''')    json
    Log    \n${object}    console=yes    
    ${lenght_object}    Get Length    ${object}
    :FOR    ${i}    IN RANGE    ${lenght_object}
    \    Log    =========== Create the user : "${object[${i}]}" ====================================    console=yes
    \    log    Hello, my name is ${object[${i}]["name"]}, i have "${object[${i}]["age"]} old" and my salary is "${object[${i}]["salary"]} $"    WARN
    \    ${object}=    Evaluate    json.loads('''${object[${i}]}''')    json    
    \    POST    /api/v1/create    ${object}    timeout=3   
    #[Teardown]    Output    response body    ${OUTPUTDIR}/new_user.demo.json
