# Azure WebPubSub demo

Azure WebPubSub demo for entre order related updates

## Folder Structure

- `lib` - Dart code for pubsub
- `html` - JavaScript code for pubsub

## How to run Dart code

- Run `dart run`
- It will run and listen for 210 seconds (3.5 mins)

## How to run the JS code

- Go to `html` folder and run a webserver
- Point your browser to that URL
- Hit *Join* and watch
- At the end hit *Disconnect*

## Special Notes

- Trying to send any unformatted data will cause socket disconnect
- Steps:
    1. Retrieve socket URL from entre order API
    2. Connect to that URL using web socket
    3. Wait and listen for connection_id
    4. Send the connection id to entre order API to addToGroup
    5. Send socket message to join that group

## Credits

- Mazhar Ahmed
- Rezaul
- Ramzan

> Copyright (c) Pounce Technology Oy