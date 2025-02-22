setInterval(() => {
    document.querySelectorAll('[data-testid="caret"]').forEach(caret => {
        caret.click();
        setTimeout(() => {
            const deleteButton = document.querySelector('[role="menuitem"][data-testid="delete"]');
            if (deleteButton) {
                deleteButton.click();
                setTimeout(() => {
                    document.querySelector('[data-testid="confirmationSheetConfirm"]')?.click();
                }, 500);
            } else {
                document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
            }
        }, 500);
    });
}, 2000);
////////////////////////
setInterval(() => {
    document.querySelectorAll('[data-testid="caret"]').forEach(
        caret => {
            caret.click();
            const deleteButton = document.querySelector('[role="menuitem"][data-testid="delete"]');
            if (deleteButton) {
                deleteButton.click();
                document.querySelector('[data-testid="confirmationSheetConfirm"]').click();
            }
            else {
                document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
            }
        });
}, 1000);
////////////////////
setInterval(() => {
    let carets = document.querySelectorAll('[data-testid="caret"]');
    let index = 0;

    function processCaret() {
        if (index >= carets.length) return;

        console.log("clicking " + index.toString());

        let caret = carets[index];
        caret.click();

        setTimeout(() => {
            //const deleteButton = document.querySelector('[role="menuitem"][data-testid="delete"]');
            //const deleteButton = $("span:contains('Delete')")[0];
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
                }, 500);

            } else {
                console.log("didn't find delete :(");
                document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' })); // Close menu
                setTimeout(() => {
                    index++;
                    processCaret();
                }, 500);
            }
        }, 500);
    }

    processCaret();
}, 5000);
//////////////////////
setInterval(() => {
    let carets = document.querySelectorAll('[data-testid="caret"]');

    for (let i = 0; i < carets.length; i++) {
        console.log("clicking " + i.toString());
        let caret = carets[i];
        caret.click();
        setTimeout(() => {
            const deleteButton = Array.from(document.querySelectorAll('span')).find(span => span.textContent.trim() === 'Delete');
            if (deleteButton) {
                deleteButton.click();

                console.log("found delete !");
                setTimeout(() => {
                    let confirmButton = document.querySelector('[data-testid="confirmationSheetConfirm"]');
                    if (confirmButton) confirmButton.click();
                }, 15);

            } else {
                console.log("didn't find delete :(");
                document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape' }));
            }
        }, 50);

    }
    setTimeout(() => {
        window.scrollBy({
            top: 1000,
            behavior: 'smooth'
        });
    }, 100);

}, 5000);