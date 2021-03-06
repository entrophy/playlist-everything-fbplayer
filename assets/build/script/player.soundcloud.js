var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

this.PlayerSoundcloud = (function(_super) {
  __extends(PlayerSoundcloud, _super);

  function PlayerSoundcloud() {}

  PlayerSoundcloud.prototype.element = function(id) {
    this.id = id;
  };

  PlayerSoundcloud.prototype.load = function(url, callback) {
    this.create();
    this._player = SC.Widget($('#pe-player-soundcloud')[0]);
    this._player.bind(SC.Widget.Events.READY, function() {
      return callback();
    });
    return this._player.load(url, {
      show_comments: false,
      liking: false,
      sharing: false,
      buying: false,
      download: false,
      show_artwork: false,
      show_playcount: false,
      show_comments: false,
      show_user: false
    });
  };

  PlayerSoundcloud.prototype.finish = function(callback) {
    if (this._player) {
      return this._player.bind(SC.Widget.Events.FINISH, callback);
    }
  };

  PlayerSoundcloud.prototype.error = function(callback) {
    return this.errorCallback = callback;
  };

  PlayerSoundcloud.prototype.play = function() {
    if (this._player) {
      return this._player.play();
    }
  };

  PlayerSoundcloud.prototype.pause = function() {
    if (this._player) {
      return this._player.pause();
    }
  };

  PlayerSoundcloud.prototype.stop = function() {
    if (this._player) {
      return this._player.pause();
    }
  };

  PlayerSoundcloud.prototype.create = function() {
    var elem;

    console.log("soundcloud create");
    elem = $('<iframe />');
    elem.attr('id', 'pe-player-soundcloud');
    elem.attr('src', 'https://w.soundcloud.com/player/?url=');
    elem.attr('frameborder', 'no');
    elem.attr('scrolling', 'no');
    elem.attr('width', '100%');
    elem.attr('height', '200');
    return $('#' + this.id).append(elem);
  };

  PlayerSoundcloud.prototype.destroy = function() {
    console.log("soundcloud destroy");
    return $('#pe-player-soundcloud').remove();
  };

  return PlayerSoundcloud;

})(this.PlayerAbstract);
