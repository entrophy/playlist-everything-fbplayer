this.UrlParser = (function() {
  function UrlParser(url) {
    var matches, regex;

    this.url = url;
    this.type = this.url.indexOf('soundcloud') !== -1 ? 'soundcloud' : this.type;
    this.type = this.url.indexOf('youtu') !== -1 ? 'youtube' : this.type;
    if (this.type === 'soundcloud') {
      this.id = this.url;
    }
    if (this.type === 'youtube') {
      regex = /(?:https?\:\/\/)?\/\/(?:[0-9A-Z-]+\.)?(?:youtu\.be\/|youtube\.com\S*[^\w\-\s])([\w\-]{11})(?=[^\w\-]|$)(?![?=&+%\w]*(?:['"][^<>]*>|<\/a>))[?=&+%\w-]*/ig;
      matches = regex.exec(this.url);
      this.id = matches[1];
    }
  }

  return UrlParser;

})();
