#!/bin/bash

# Create the extension directory structure
mkdir -p chatgpt_to_pdf_extension/images

# Create the manifest.json file
cat <<EOF > chatgpt_to_pdf_extension/manifest.json
{
  "manifest_version": 2,
  "name": "ChatGPT to PDF",
  "version": "1.0",
  "description": "Save ChatGPT conversations to PDF",
  "permissions": [
    "activeTab",
    "downloads"
  ],
  "browser_action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "images/icon16.png",
      "48": "images/icon48.png",
      "128": "images/icon128.png"
    }
  },
  "background": {
    "scripts": ["background.js"],
    "persistent": false
  }
}
EOF

# Create the popup.html file
cat <<EOF > chatgpt_to_pdf_extension/popup.html
<!DOCTYPE html>
<html>
<head>
  <title>ChatGPT to PDF</title>
  <style>
    body { font-family: Arial, sans-serif; }
    button { margin: 10px; padding: 10px; }
  </style>
</head>
<body>
  <h1>ChatGPT to PDF</h1>
  <button id="savePdf">Save Conversation as PDF</button>
  <script src="popup.js"></script>
  <script src="jspdf.min.js"></script>
</body>
</html>
EOF

# Create the popup.js file
cat <<EOF > chatgpt_to_pdf_extension/popup.js
document.getElementById('savePdf').addEventListener('click', function () {
  chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
    chrome.tabs.sendMessage(tabs[0].id, { action: "savePdf" });
  });
});
EOF

# Create the content.js file
cat <<EOF > chatgpt_to_pdf_extension/content.js
chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
  if (request.action === "savePdf") {
    const userMessages = document.querySelectorAll(".user-message-selector");
    const botMessages = document.querySelectorAll(".bot-message-selector");

    let conversation = "";
    userMessages.forEach((message, index) => {
      const userText = message.innerText.trim();
      const botText = botMessages[index] ? botMessages[index].innerText.trim() : '';
      conversation += \`User: \${userText}\nChatGPT: \${botText}\n\n\`;
    });

    chrome.runtime.sendMessage({ action: "generatePdf", data: conversation });
  }
});
EOF

# Create the background.js file
cat <<EOF > chatgpt_to_pdf_extension/background.js
chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
  if (request.action === "generatePdf") {
    generatePdf(request.data);
  }
});

function generatePdf(content) {
  var doc = new jsPDF();
  var lines = doc.splitTextToSize(content, 180);
  doc.text(lines, 10, 10);
  var pdfOutput = doc.output('blob');

  var link = document.createElement('a');
  link.href = URL.createObjectURL(pdfOutput);
  link.download = 'ChatGPT_Conversation.pdf';
  link.click();
}
EOF

# Download jsPDF library
curl -o chatgpt_to_pdf_extension/jspdf.min.js https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.4.0/jspdf.umd.min.js

# Create the README.md file
cat <<EOF > chatgpt_to_pdf_extension/README.md
# ChatGPT to PDF Extension

This Edge extension allows you to save ChatGPT conversations as a PDF file.

## Installation Instructions

1. Open Microsoft Edge and navigate to \`edge://extensions\`.
2. Enable "Developer mode" by toggling the switch in the bottom left corner.
3. Click "Load unpacked" and select the \`chatgpt_to_pdf_extension\` directory.
4. The extension should now be loaded and ready to use.

## Usage Instructions

1. Open ChatGPT in your browser.
2. Click on the ChatGPT to PDF extension icon in the toolbar.
3. Click the "Save Conversation as PDF" button.
4. The conversation will be saved as a PDF file.

## Notes

- Make sure to adjust the selectors in \`content.js\` (i.e., \`.user-message-selector\` and \`.bot-message-selector\`) to match the actual structure of the ChatGPT conversation elements.
EOF

echo "Edge extension files have been created successfully in the chatgpt_to_pdf_extension directory."

# Open Microsoft Edge and navigate to the extensions page
if command -v microsoft-edge &> /dev/null
then
    microsoft-edge edge://extensions
elif command -v microsoft-edge-stable &> /dev/null
then
    microsoft-edge-stable edge://extensions
else
    echo "Microsoft Edge not found. Please open edge://extensions manually."
fi

