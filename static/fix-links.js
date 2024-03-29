"use strict";

document.addEventListener("DOMContentLoaded", () => {
  const production_base_url = new URL("https://backoffice.seattleflu.org/switchboard");

  /* Fix broken links generated by Datasette when deployed at a subpath instead
   * of the web root.  See <https://github.com/simonw/datasette/issues/838>.
   * This is kinda terrible, but at least it makes the links work.  It seemed
   * more palatable than configuring Apache (our reverse proxy) to rewrite all
   * HTML from Datasette using mod_proxy_html.
   *   -trs, 2 July 2020
   */
  if (document.location.origin !== production_base_url.origin) {
    console.debug(`fix-links: skipping page; origin ${document.location.origin} is not ${production_base_url.origin}`)
    return;
  }

  const broken_link = url =>
       url.origin !== production_base_url.origin
    && url.origin.match(/localhost|127[.]0[.]0[.]1/);

  for (const anchor of document.querySelectorAll("a[href]")) {
    if (broken_link(anchor)) {
      console.debug(`fix-links: fixing ${anchor.href}`);

      anchor.protocol = production_base_url.protocol;
      anchor.hostname = production_base_url.hostname;
      anchor.port     = production_base_url.port;

      if (!anchor.pathname.startsWith(production_base_url.pathname))
        anchor.pathname = production_base_url.pathname + anchor.pathname;

      console.debug(`fix-links: fixed ${anchor.href}`);
    }
    else {
      console.debug(`fix-links: skipping ${anchor.href}; origin is not localhost`);
    }
  }
});
