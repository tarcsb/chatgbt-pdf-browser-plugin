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
