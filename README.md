
# [Sendbird](https://sendbird.com) Sendbird X ChatGPT Healthcare AI Chatbot Demo

[![Platform](https://img.shields.io/badge/platform-iOS-orange.svg)](https://cocoapods.org/pods/SendBirdUIKit)
[![Languages](https://img.shields.io/badge/language-Swift-orange.svg)](https://github.com/sendbird/sendbird-uikit-ios)
[![Commercial License](https://img.shields.io/badge/license-Commercial-green.svg)](https://github.com/sendbird/sendbird-uikit-ios/blob/main/LICENSE.md)

This demo app showcases what AI Chatbots with Sendbird can do to enhance the customer experience of your service with more personalized and comprehensive customer support.
Utilizing OpenAI’s GPT3.5 and its Function Calling functionality, ***Sendbird helps you build a chatbot that can go extra miles: providing informative responses with the data source you feed to the bot, accommodating customer’s requests such as retrieving appointment information and making an appointment and even talking to the doctor.*** Create your own next generation AI Chatbot by following the tutorial below.

![healthcare](https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/fa99d8a0-9cee-44c3-9300-18889a37141f)

## Prerequisites
1. [Sendbird Account](https://dashboard.sendbird.com/)
2. Application ID and ChatBot: Please refer to [Step1 ~ Step4](https://sendbird.com/developer/tutorials/create-an-ai-chatbot), In `Step3`, you can use the following `system_message` for the demo app.
   - [Knowledgebase file for initial symptoms](https://github.com/sendbird/chat-ai-green-vertical-contents/blob/github-pages/healthcare_result_resize.txt)
     ```
      Title: Airplane ear
      When to see a doctor:'... The gene change may result in no melanin at all or a big decrease in the amount ...
      Complications: Albinism can include skin and eye complications. It also can include ...
      Overview: OCA Symptoms of albinism are usually seen in a person's skin, hair andeye color, but sometimes ...
      Prevention: If a family member has albinism, a genetic counselor can help you ...
      Risk factors: ...
      Symptoms: Symptoms of albinism involve skin, hair and eye color, as well as vision.Skin The easiest form of albinism to see results ...
     
      ... 
     ```

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
1. [Use case: Healthcare](#use-case-healthcare)
2. [How it works](#how-it-works)
3. [Demo app settings](#demo-app-settings)
4. [System Message](#system-message)
5. [Function Calls](#function-calls)
5. [Welcome Message and Suggestions](#welcome-message-and-suggested-replies)
6. [UI Components](#ui-components)
7. [Limitations](#limitations)

## Use case: Healthcare
This demo app demonstrates the implementation of the AI Chatbot tailored for healthcare. It includes functionalities such as ***suggesting possible appointment dates, making an appointment, and talking to the doctor.*** By leveraging ChatGPT’s new feature [Function Calling](https://openai.com/blog/function-calling-and-other-api-updates), the Chatbot now can make an API request to the 3rd party with a predefined Function Calling based on customer’s enquiry. Then it parses and presents the response in a conversational manner, enhancing overall customer experience.

## How it works
<img width="2593" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/0627f6f0-0dd1-4118-a268-45f71083e8c4">

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
To run the demo app, you must specify `System prompt` and `Function Calls`.

### System Message
`System prompt` defines the Persona of the ChatBot, informing users of the role the ChatBot plays. For this Healthcare AI ChatBot, it's designed to assist patients with initial symptom diagnosis and making appointments. The `System prompt` has been defined as follows:

You can find this setting under Chat > AI Chatbot > Manage bots > Edit > Bot settings > Parameter settings > System prompt.

- Input example
  <img width="1000" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/91c319b6-cccb-4e06-a7ba-29341d4c0fcc">

```
You are an AI assistant designed to handle and manage patient inquiries and appointments in a comprehensive hospital setting.

1. Available 24/7 to assist patients with their symptom descriptions and appointment requests.
2. Patients may provide descriptions of their new symptoms and request for an analysis of their condition based on these symptoms.
3. You have access to the patient's basic information and past medical history.
4. After a patient has described their symptoms, you should recommend the most appropriate department for the patient's condition.
5. Once the department has been recommended, ask the patient if they would like assistance in scheduling an appointment with the recommended department.
6. Once an appointment is successfully made, you need to confirm the appointment details to the patient.
7. Be prepared to provide continued assistance if the patient needs further help after the appointment has been made.
```

### Function Calls
`Function Calls` allows you to define situations where the ChatBot needs to interface with external APIs. Within `Function Calls`, you need to enter definitions for the Function and Parameters to pass to GPT, and you can define the specs of the 3rd party API to obtain the actual data of the specified Function.

You can find this setting under Chat > AI Chatbot > Settings > Function Calls. 

- Example list of Function Calls
  <img width="1000" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/77be8334-66f4-4b25-8911-f3ec62a5093a">

- Input example
  <img width="1000" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/b2e71269-5cba-4fb4-bc4d-6a0d340c2ca7">

In addition, you can enhance user experience by streamlining the communication with a Welcome Message, Quick Replies and Button. Using Quick Replies can improve the clarity of your customer’s intention as they are presented with a list of predefined options determined by you.

Mock API Server Information: [Link](https://documenter.getpostman.com/view/21816899/2s9Y5eMJvT)

## Welcome Message and Suggested Replies
<img width="382" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/7202d855-f08c-46c0-ac04-4af0aedb4cae">

The `Welcome Message` is the first message displayed to users by the chatbot. Along with the `Welcome Message`, you can also set up `Suggested Replies` from the Dashboard.

You can find this setting under Chat > AI Chatbot > Manage bots > Edit > Bot settings > Default messages > Welcome message / Suggested replies.

- Input example
  <img width="1000" alt="image" src="https://github.com/sendbird/healthcare-ai-chatbot/assets/104121286/22d3ad2b-7d2b-4618-ab83-6e0c621bbe9a">


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

[SBUUserMessageCell.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/View/Channel/MessageCell/SBUUserMessageCell.swift#L175)
```swift
// MARK: Card List
if let cardListView = self.cardListView {
    self.contentVStackView.removeArrangedSubview(cardListView)
}

let functionResponse = json["function_calls"][0]

if functionResponse.type != .null {
    let statusCode = functionResponse["status_code"].intValue
    let functionName = functionResponse["name"].stringValue
    let response = functionResponse["response_text"]

    if statusCode == 200 {
        if ... {
         ...
        } else if functionName.contains("post_appointments") {
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
                    title: "Date: \(json["appointmentDetails"]["date"].stringValue) \(json["appointmentDetails"]["time"].stringValue)",
                    subtitle: nil,
                    description: "- ID: \(json["appointmentDetails"]["appointmentId"].stringValue)\n- Department: \(json["appointmentDetails"]["department"].stringValue)\n- Doctor: \(json["appointmentDetails"]["doctor"].stringValue)",
                    link: nil
                )

                return [orderParams]
            }
            if let items = try?SBUGlobalCustomParams.cardViewParamsCollectionBuilder?(response.rawString()!){
                self.addCardListView(with: items)
            }
        } else if functionName.contains("get_recommend_date") {
            // Replace the message text with the custom text
            customText = "Here are the available appointment date and time. Click the card if you have a desired appointment."
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
                            subtitle: "Date: \(item["recommended_date"].stringValue)",
                            description: nil,
                            link: nil,
                            actionHandler: {
                                self.cardSelectHandler!("Please reserve a reservation with \(item["doctor"].stringValue), \(item["recommended_date"].stringValue)")
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

if let quickReplies = json["quick_replies"].arrayObject as? [String], !quickReplies.isEmpty {
    self.updateQuickReplyView(with: quickReplies)
}
```

### ButtonView
The following codes demonstrate how to set the view for Buttons. When the server returns a response that includes the information of adding a button to call the action, by setting the `SBUButtonViewParams` and `updateButtonView(with: buttonParams)`, the button is displayed in the message. The following codes show how to set the Button view of the doctor reservation.

- `actionText`: the text to be displayed on the button
- `description`: the text to be displayed below the button
- `actionHandler`: the action to be performed when the button is clicked
- `enableButton`: whether the button is enabled or not
- `disableButtonText`: the text to be displayed on the button when it is disabled

[SBUUserMessageCell.swift](https://github.com/sendbird/healthcare-ai-chatbot/blob/develop/Sources/View/Channel/MessageCell/SBUUserMessageCell.swift#L170)
```swift
// MARK: ButtonView
if let buttonView = self.buttonView {
    self.contentVStackView.removeArrangedSubview(buttonView)
}

let functionResponse = json["function_calls"][0]

if functionResponse.type != .null {
    let statusCode = functionResponse["status_code"].intValue
    let functionName = functionResponse["name"].stringValue
    let response = functionResponse["response_text"]

    if statusCode == 200 {
        if functionName.contains("check_doctors_availability") {
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
