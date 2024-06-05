chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
  if (request.action === "savePdf") {
    const userMessages = document.querySelectorAll(".user-message-selector");
    const botMessages = document.querySelectorAll(".bot-message-selector");

    let conversation = "";
    userMessages.forEach((message, index) => {
      const userText = message.innerText.trim();
      const botText = botMessages[index] ? botMessages[index].innerText.trim() : '';
      conversation += `User: ${userText}\nChatGPT: ${botText}\n\n`;
    });

    chrome.runtime.sendMessage({ action: "generatePdf", data: conversation });
  }
});
