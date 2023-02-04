// Allows hover highlighting for cases that CSS :hover won't work for --
// particularly when elements need to be highlighted that aren't descendants
// of the hovered element.  Also supports highlight-on-tap for mouseless
// (read: mobile) UAs.
function addHoverHandlers (root) {
    var currentSelector = null;

    let select = (selector) => {
        if (selector == currentSelector) {
            return;
        }
        if (currentSelector !== null) {
            for (el of root.querySelectorAll(currentSelector)) {
                el.classList.remove('hover-highlight');
            }
        }
        if (selector !== null) {
            for (el of root.querySelectorAll(selector)) {
                el.classList.add('hover-highlight');
            }
        }
        currentSelector = selector;
    }

    root.addEventListener('mouseenter', (ev) => {
        let selector = ev.target.getAttribute('data-hover');
        if (selector !== null) {
            select(selector);
        }
    }, true)

    root.addEventListener('mouseleave', (ev) => {
        let selector = ev.target.getAttribute('data-hover');
        if (selector !== null && currentSelector === selector) {
            select(null);
        }
    }, true)

    document.addEventListener('click', (ev) => {
        var selector = null;
        if (root.contains(ev.target)) {
            selector = ev.target.getAttribute('data-hover');
        }
        select(selector);
    }, true)
}

for (el of document.querySelectorAll('.hover-root')) {
    addHoverHandlers(el);
}
