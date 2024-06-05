# ChatGPT to PDF Extension

This Edge extension allows you to save ChatGPT conversations as a PDF file.

## Installation Instructions

1. Open Microsoft Edge and navigate to `edge://extensions`.
2. Enable "Developer mode" by toggling the switch in the bottom left corner.
3. Click "Load unpacked" and select the `chatgpt_to_pdf_extension` directory.
4. The extension should now be loaded and ready to use.

## Usage Instructions

1. Open ChatGPT in your browser.
2. Click on the ChatGPT to PDF extension icon in the toolbar.
3. Click the "Save Conversation as PDF" button.
4. The conversation will be saved as a PDF file.

## Notes

- Make sure to adjust the selectors in `content.js` (i.e., `.user-message-selector` and `.bot-message-selector`) to match the actual structure of the ChatGPT conversation elements.
