var type_map;

type_map = {
  'www.youtube.com': 'Youtube',
  'youtu.be': 'Youtube',
  'youtube.com': 'Youtube',
  'soundcloud.com': 'Soundcloud'
};

this.Song = (function() {
  Song.YOUTUBE = 'Youtube';

  Song.SOUNDCLOUD = 'Soundcloud';

  Song.prototype.url_domain = function(url) {
    var a;

    a = document.createElement('a');
    a.href = url;
    return a.hostname;
  };

  function Song(data) {
    this.id = data.id;
    this.title = data.name;
    this.link = data.link;
    this.domain = this.url_domain(this.link);
    this.origin = type_map[this.domain];
    this.playable = !!this.origin;
  }

  return Song;

})();
