(() => {
  const toggles = document.querySelectorAll('[data-mobile-menu-toggle]');
  if (!toggles.length) return;

  toggles.forEach((toggle) => {
    const menuId = toggle.getAttribute('aria-controls');
    const menu = menuId ? document.getElementById(menuId) : null;
    if (!menu) return;

    const links = Array.from(menu.querySelectorAll('a, button'));
    let hideTimer = null;

    const setMenuLinksEnabled = (enabled) => {
      links.forEach((link) => {
        if (enabled) {
          link.removeAttribute('tabindex');
        } else {
          link.setAttribute('tabindex', '-1');
        }
      });
    };

    const setOpen = (open) => {
      clearTimeout(hideTimer);
      toggle.classList.toggle('is-open', open);
      toggle.setAttribute('aria-expanded', String(open));
      menu.setAttribute('aria-hidden', String(!open));
      setMenuLinksEnabled(open);

      if (open) {
        menu.hidden = false;
        requestAnimationFrame(() => {
          menu.classList.add('open');
        });
        return;
      }

      menu.classList.remove('open');
      hideTimer = setTimeout(() => {
        if (!menu.classList.contains('open')) {
          menu.hidden = true;
        }
      }, 280);
    };

    setOpen(false);

    toggle.addEventListener('click', (event) => {
      event.stopPropagation();
      setOpen(toggle.getAttribute('aria-expanded') !== 'true');
    });

    menu.addEventListener('click', (event) => {
      if (event.target.closest('a')) {
        setOpen(false);
      }
    });

    document.addEventListener('click', (event) => {
      if (menu.hidden) return;
      if (toggle.contains(event.target) || menu.contains(event.target)) return;
      setOpen(false);
    });

    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape' && !menu.hidden) {
        setOpen(false);
        toggle.focus();
      }
    });

    window.addEventListener('resize', () => {
      if (window.innerWidth > 900) {
        setOpen(false);
      }
    });
  });
})();
