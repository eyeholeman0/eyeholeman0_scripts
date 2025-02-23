/// Delete all tweets/replies 
/// navigate to the tweets/replies page and run the script in browser console
setInterval(() => {
    let carets = document.querySelectorAll('[data-testid="caret"]');
    let index = 0;
    function processCaret() {
        if (index >= carets.length){
            return;
        }
        console.log("clicking " + index.toString());
        let caret = carets[index];
        caret.click();

        setTimeout(() => {
            const deleteButton = Array.from(document.querySelectorAll('span')).find(span => span.textContent.trim() === 'Delete');
            if (deleteButton) {
                deleteButton.click();
                console.log("found delete !");
                setTimeout(() => {
                    let confirmButton = document.querySelector('[data-testid="confirmationSheetConfirm"]');
                    if (confirmButton) confirmButton.click();

                    setTimeout(() => {
                        index++;
                        processCaret();
                    }, 1000);
                }, 50);

            } else {
                console.log("didn't find delete :(");
                document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
                setTimeout(() => {
                    index++;
                    processCaret();
                }, 10);
            }
        }, 50);
    }

    processCaret();
    window.scrollBy({
        top: 1000,
        behavior: 'smooth'
    });
}, 10000);