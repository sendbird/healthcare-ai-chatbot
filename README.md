
# [Sendbird](https://sendbird.com) Sendbird X ChatGPT Healthcare AI Chatbot Demo

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://cocoapods.org/pods/SendBirdUIKit)
[![Languages](https://img.shields.io/badge/language-Swift-orange.svg)](https://github.com/sendbird/sendbird-uikit-ios)
[![Commercial License](https://img.shields.io/badge/license-Commercial-green.svg)](https://github.com/sendbird/sendbird-uikit-ios/blob/main/LICENSE.md)

This demo app showcases what AI Chatbots with Sendbird can do to enhance the customer experience of your service with more personalized and comprehensive customer support.
Utilizing OpenAI’s GPT3.5 and its Function Calling functionality, ***Sendbird helps you build a chatbot that can go extra miles: providing informative responses with the data source you feed to the bot, accommodating customer’s requests such as retrieving reservation information and making a reservation and even talking to the doctor.*** Create your own next generation AI Chatbot by following the tutorial below.

![healthcare](https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/04d71cea-8044-4b70-9cd6-9de3e2d95f5b)

## Prerequisites
1. [Sendbird Account](https://dashboard.sendbird.com/)
2. Application ID and ChatBot: Please refer to [Step1 ~ Step4](https://sendbird.com/developer/tutorials/create-an-ai-chatbot), In `Step3`, you can use the following `system_message` for the demo app.
   - Healthcare `system_message` example
    ```
    You are an AI assistant designed to handle and manage patient inquiries and appointments in a comprehensive hospital setting.
    
   1. Available 24/7 to assist patients with their symptom descriptions and appointment requests.
   2. Patients may provide descriptions of their new symptoms and request for an analysis of their condition based on these symptoms.
   3. You have access to the patient's basic information and past medical history.
   4. After a patient has described their symptoms, you should recommend the most appropriate department for the patient's condition.
   5. Once the department has been recommended, ask the patient if they would like assistance in scheduling an appointment with the recommended department.
   6. Once an appointment is successfully made, you need to confirm the appointment details to the patient.
   7. Be prepared to provide continued assistance if the patient needs further help after the appointment has been made.
   
   And from now on, the person you're speaking to is named John Doe, and the patient ID is P12345.
    ```
    <img width="449" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/934e0b42-5475-44f4-a767-b472d4efe150">


## How to open the demo app
1. Open Xcode Demo project
```shell
open Sample/QuickStart.xcodeproj
```
2. Set the `applicationId` and `botId` in [`AppDelegate.swift`](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sample/QuickStart/AppDelegate.swift#L13-L14)
```swift
static let botId: String = <#botId: String#>
static let applicationId: String = <#applicationId: String#>
```

## Table of Contents
1. [Use case: Healthcare](##use-case-healthcare)
2. [How it works](##how-it-works)
3. [Demo app settings](##demo-app-settings)
4. [System Message and Function Calling](##system-message-and-function-calling)
5. [Welcome Message and Quick Replies](##welcome-message-and-quick-replies)
6. [UI Components](##ui-components)
7. [Limitations](##limitations)

## Use case: Healthcare
This demo app demonstrates the implementation of the AI Chatbot tailored for healthcare. It includes functionalities such as ***recommend date to reservation, reservation, Talking to the doctor.*** By leveraging ChatGPT’s new feature [Function Calling](https://openai.com/blog/function-calling-and-other-api-updates), the Chatbot now can make an API request to the 3rd party with a predefined Function Calling based on customer’s enquiry. Then it parses and presents the response in a conversational manner, enhancing overall customer experience.

## How it works
<img width="2533" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/e20eb8da-9f62-4c03-b95f-2d1a3f9daef7">

1. A customer sends a message containing a specific request on the client app to the Sendbird server.
2. The Sendbird server then delivers the message to Chat GPT.
3. Chat GPT then analyzes the message and determines that it needs to make a Function Calling request. In response, it delivers the relevant information to the Sendbird server.
4. The Sendbird server then sends back a Function Calling request to Chat GPT. The request contains both Function Calling data Chat GPT previously sent and the 3rd party API information provided by the client app. This configuration must be set on the client-side.
5. The 3rd party API returns a response in `data` to the Sendbird server.
6. The Sendbird server passes the `data` to Chat GPT.
7. Once received, Chat GPT analyzes the data and returns proper responses to the Sendbird server as `data`.
8. The Sendbird server passes Chat GPT’s answer to the client app.
9. The client app can process and display the answer with Sendbird Chat UIKit.

***Note***: Currently, calling a 3rd party function is an experimental feature, and some logics are handled on the client-side for convenience purposes. Due to this, the current version for iOS (3.7.0 beta) will see breaking changes in the future, especially for QuickReplyView and CardView. Also, the ad-hoc support from the server that goes into the demo may be discontinued at any time and will be replaced with a proper feature on Sendbird Dashboard in the future.

## Demo app settings
To run the demo app, you must specify `functions` in `ai_attrs`. Each provides the AI Chatbot with directions on how to interpret a customer’s message and respond to it using the predefined functions.

In addition, you can enhance user experience by streamlining the communication with a Welcome Message, Quick Replies and Button. Using Quick Replies can improve the clarity of your customer’s intention as they are presented with a list of predefined options determined by you.

## System Message and Function Calling
The `functions` value in `ai_attrs` contains information related to Function Calling, which are a list of functions that Chat GPT can call and the 3rd party API information to send the Function Calling request to.
And `ai_attrs` value will be stored in the `messageParams.data` property in `string`.

`ai_attrs` 
 - `functions`: this contains information related to Function Calling, which are a list of functions that Chat GPT can call and the 3rd party API information to send the Function Calling request to.
   - `request`: 3rd party API information
      - `headers`: header for the api request
     - `method`: a method for the API request, such as `GET`, `POST`, `PUT`, or `DELETE`
     - `url`: the API request URL
   - `name`: the name of the Function Calling request
   - `description`: the description about the Function Calling request. It can detail when to call the function and what action to be taken. Chat GPT will use this information to analyze the customer’s message and determine whether to call the function or not.
   - `parameter`: This contains a list of arguments required for the Function Calling.

Mock API Server Information: [Link](https://documenter.getpostman.com/view/21816899/2s9Xy3qqFd)

[SBUBaseChannelViewModel.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/ViewModel/Channel/SBUBaseChannelViewModel.swift#L221)
```swift
let data = """
    {
        "ai_attrs": {
            "functions": [
                {
                    "request": {
                        "headers": {},
                        "method": "GET",
                        "url": "https://9f306185-0c00-410f-a0d1-96e8cfbf5f2f.mock.pstmn.io/get_reservation"
                    },
                    "quick_replies": [
                        "I don't feel well.",
                        "Can I check my previous medical records?",
                        "Can I talk to a doctor?"
                    ],
                    "name": "get_reservation",
                    "description": "Check the patient's reservation information through the patient ID",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "patientId": {
                                "type": "string",
                                "description": "patient ID"
                            }
                        },
                        "required": ["patientId"]
                    }
                },
                {
                    "request": {
                        "headers": {},
                        "method": "GET",
                        "url": "https://9f306185-0c00-410f-a0d1-96e8cfbf5f2f.mock.pstmn.io/get_medical_history"
                    },
                    "quick_replies": [
                        "I don't feel well.",
                        "Can I check my reservation information?",
                        "Can I talk to a doctor?"
                    ],
                    "name": "get_medical_history",
                    "description": "Check the patient's medical history through the patient's ID",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "patientId": {
                                "type": "string",
                                "description": "patient ID"
                            }
                        },
                        "required": ["patientId"]
                    }
                },
                {
                    "request": {
                        "headers": {},
                        "method": "GET",
                        "url": "https://9f306185-0c00-410f-a0d1-96e8cfbf5f2f.mock.pstmn.io/recommend_date"
                    },
                    "quick_replies": [
                        "I want to make an reservation",
                        "I want to know other schedule later than this date"
                    ],
                    "name": "recommend_date",
                    "description": "Possible appointment dates and doctor information for your department, If the Preferred reservation date is not entered, it returns the earliest possible schedule after the current date.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "department": {
                                "type": "string",
                                "description": "the department in charge"
                            },
                            "preferred_reservation_date": {
                                "type": "string",
                                "description": "Preferred reservation date"
                            }
                        },
                        "required": ["department"]
                    }
                },
                {
                    "request": {
                        "headers": {},
                        "method": "GET",
                        "url": "https://9f306185-0c00-410f-a0d1-96e8cfbf5f2f.mock.pstmn.io/check_availability"
                    },
                    "quick_replies": [
                        "I want to make an reservation",
                        "Can I talk to a doctor?"
                    ],
                    "name": "check_availability",
                    "description": "Confirmation of availability with desired date. If the doctor information is not entered, if there is a doctor available on the day, it is automatically assigned.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "department": {
                                "type": "string",
                                "description": "the department in charge"
                            },
                            "preferred_reservation_date": {
                                "type": "string",
                                "description": "Preferred reservation date"
                            },
                            "preferred_doctor_name": {
                                "type": "string",
                                "description": "Doctor Name"
                            }
                        },
                        "required": ["department", "preferred_reservation_date"]
                    }
                },
                {
                    "request": {
                        "headers": {},
                        "method": "POST",
                        "url": "https://9f306185-0c00-410f-a0d1-96e8cfbf5f2f.mock.pstmn.io/reservation"
                    },
                    "quick_replies": [
                        "Thank you",
                        "Can I talk to a doctor?"
                    ],
                    "name": "reservation",
                    "description": "Proceed with the reservation. If the doctor information is not entered, if there is a doctor available on the day, it is automatically assigned.If there is no available date, return recommend another date.",
                    "parameters": {
                        "type": "object",
                        "properties": {
                            "department": {
                                "type": "string",
                                "description": "the department in charge"
                            },
                            "preferred_reservation_date": {
                                "type": "string",
                                "description": "Preferred reservation date"
                            },
                            "preferred_doctor_name": {
                                "type": "string",
                                "description": "Doctor Name"
                            }
                        },
                        "required": ["department", "preferred_reservation_date"]
                    }
                },
                {
                    "request": {
                        "headers": {},
                        "method": "GET",
                        "url": "https://9f306185-0c00-410f-a0d1-96e8cfbf5f2f.mock.pstmn.io/check_availability_of_doctor_for_consultation"
                    },
                    "name": "check_availability_of_doctor_for_consultation",
                    "description": "Check if it's currently possible to talk to the doctor.",
                    "parameters": {
                        "type": "object",
                        "properties": {},
                        "required": []
                    }
                }
            ]
        }
    }
"""
```

## Welcome Message and Quick Replies
<img width="387" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/40b3d20d-f8e6-44b4-889f-e7b39758b901">

The following is a prompt sample of `first_message_data` in `json` format. The object contains two pieces of information: `message` and `data`. The string value in message will act as a Welcome Message while values in `data` represent the Quick Replies that the customer can choose from. The keys and values in the prompt will be stored in the `channelCreateParams.data` property in `string`.

`first_message_data`
 - `data`: you can use Quick Replies as a preset of messages that a customer can choose from. These Quick Replies will be displayed with its own UI components. Use `option` for Quick Replies in the `data` object
   - `options`: this contains a list of Quick Reply messages. A customer can choose a predefined item from the list, which enhances the clarity of the customer’s request and thus helps the AI Chatbot understand their intention.
 - `message`: this is a Welcome Message to greet a customer when they open a channel and initiate conversation with an AI ChatBot. 

[SBUCreateChannelViewModel.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/ViewModel/SelectUser/CreateChannel/SBUCreateChannelViewModel.swift#L223)
```swift
let data: [String: Any] = [
    "first_message_data": [
        [
            "data": [],
            "message": "Hi I’m Healthcare ChatBot."
        ],
        [
            "data": [
                "options": [
                    "I don't feel well.",
                    "Can I check my previous medical records?",
                    "Can I check my reservation information?"
                ]
            ],
            "message": "I'm still learning but I'm here 24/7 to answer your question or connect you with the right person to help."
        ]
    ]
]
                
do {
    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        params.data = jsonString
    }
} catch {
    print("Error while converting to JSON: \(error)")
}
```

## UI Components
### CardView
The `data` in the response are displayed in a Card view. In the demo, information such as order items and their delivery status can be displayed in a card with an image, title, and description. Customization of the view can be done through `cardViewParamsCollectionBuilder` and `SBUCardViewParams`. The following codes show how to set the Card view of order status.

- `imageURL`: the URL of the image to be displayed on the card
- `title`: the title to be displayed on the card
- `subtitle`: the subtitle to be displayed on the card
- `description`: the description to be displayed on the card
- `link`: the link to be displayed on the card
  (If actionHandler is set, link is ignored.)
- `actionHandler`: the action to be performed when the card is clicked

[SBUUserMessageCell.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/View/Channel/MessageCell/SBUUserMessageCell.swift#L180)
```swift
// MARK: Card List
if let cardListView = self.cardListView {
   self.contentVStackView.removeArrangedSubview(cardListView)
}

let functionResponse = json["function_response"]

if functionResponse.type != .null {
   let statusCode = functionResponse["status_code"].intValue
   let endpoint = functionResponse["endpoint"].stringValue
   let response = functionResponse["response"]

   if statusCode == 200 {
       if ... {
         ...
       } else if endpoint.contains("/reservation") {
           // Replace the message text with the custom text
           customText = "Your appointment has been successfully scheduled. Here are the details"
           SBUGlobalCustomParams.cardViewParamsCollectionBuilder = { messageData in
               guard
                   let data = messageData.data(using: .utf8),
                   let json = try? JSON(data: data)
               else { return [] }
               // Convert the single order object into a SBUCardViewParams object
               let orderParams = SBUCardViewParams(
                   imageURL: nil,
                   title: "Date: \(json["appointmentDetails"]["date"].stringValue):\(json["appointmentDetails"]["time"].stringValue)",
                   subtitle: nil,
                   description: "- ID: \(json["appointmentDetails"]["appointmentId"].stringValue)\n- Department: \(json["appointmentDetails"]["department"].stringValue)\n- Doctor: \(json["appointmentDetails"]["doctor"].stringValue)",
                   link: nil
               )

               return [orderParams]
           }
           if let items = try?SBUGlobalCustomParams.cardViewParamsCollectionBuilder?(response.rawString()!){
               self.addCardListView(with: items)
           }
       } else if endpoint.contains("/recommend_date") {
           // Replace the message text with the custom text
           customText = "Here are the available appointment date and time."
           disableWebview = true
           SBUGlobalCustomParams.cardViewParamsCollectionBuilder = { messageData in
               guard
                   let data = messageData.data(using: .utf8),
                   let json = try? JSON(data: data)
               else { return [] }
               return json.arrayValue.compactMap { item in
                   return SBUCardViewParams(
                           imageURL: nil,
                           title: "\(item["doctor"].stringValue)",
                           subtitle: "Date: \(item["recommend_date"].stringValue)",
                           description: nil,
                           link: nil,
                           actionHandler: {
                               self.cardSelectHandler!("Please reserve a reservation with \(item["doctor"].stringValue), \(item["recommend_date"].stringValue)")
                           }
                   )
               }
           }
           if let items = try?SBUGlobalCustomParams.cardViewParamsCollectionBuilder?(response.rawString()!){
               self.addCardListView(with: items)
           }
       }
   }
} else {
   self.cardListView = nil
}

```

### QuickReplyView
The following codes demonstrate how to set the view for Quick Replies. The values in `options` of `first_message_data.data` are used as Quick Replies.
When the user clicks on the Quick Reply, the message is sent to the server.

[SBUUserMessageCell.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/View/Channel/MessageCell/SBUUserMessageCell.swift#L160)
```swift
// MARK: Quick Reply        
if let quickReplyView = self.quickReplyView {
    quickReplyView.removeFromSuperview()
    self.quickReplyView = nil
}

if let replyOptions = message.quickReply?.options, !replyOptions.isEmpty {
    self.updateQuickReplyView(with: replyOptions)
}
```

### ButtonView
The following codes demonstrate how to set the view for Buttons. When the server returns a response that includes the information of adding a button to call the action, by setting the `SBUButtonViewParams` and `updateButtonView(with: buttonParams)`, the button is displayed in the message. The following codes show how to set the Button view of the doctor reservation.

- `actionText`: the text to be displayed on the button
- `description`: the text to be displayed below the button
- `actionHandler`: the action to be performed when the button is clicked
- `enableButton`: whether the button is enabled or not
- `disableButtonText`: the text to be displayed on the button when it is disabled

[SBUUserMessageCell.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/View/Channel/MessageCell/SBUUserMessageCell.swift#L175)
```swift
// MARK: ButtonView
if let buttonView = self.buttonView {
    self.contentVStackView.removeArrangedSubview(buttonView)
}

let functionResponse = json["function_response"]

if functionResponse.type != .null {
    let statusCode = functionResponse["status_code"].intValue
    let endpoint = functionResponse["endpoint"].stringValue
    let response = functionResponse["response"]

    if statusCode == 200 {
        if endpoint.contains("/check_availability_of_doctor_for_consultation") {
           // Replace the message text with the custom text
           customText = "Yes, you can talk to a doctor. "
           
           let buttonParams = SBUButtonViewParams(
               actionText: "Invite a Doctor",
               description: "If you want to talk to a doctor, please click the button!",
               actionHandler: {
                   self.buttonClicked = true
                   self.buttonSelectHandler!()
                   self.layoutIfNeeded()
               },
               enableButton: !shouldHideButton && !self.buttonClicked,
               disableButtonText: "In Progress"
           )
           self.updateButtonView(with: buttonParams)
        } 
        ...
    }
}

```

## Limitations
`Tokens`
The maximum number of tokens allowed for `data` is 4027. Make sure that the settings information including the system message does not exceed the limit.
