var _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

this.Player = (function(_super) {
  __extends(Player, _super);

  function Player() {
    _ref = Player.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  Player.Events = {
    READY: 'ready'
  };

  Player.prototype.element = function(id) {
    this.id = id;
  };

  Player.prototype.load = function(url, callback) {
    url = new UrlParser(url);
    if (this._player) {
      this._player.destroy();
    }
    if (url.type === 'soundcloud') {
      this._player = new PlayerSoundcloud();
      this._player.element(this.id);
      this._player.load(url.id, callback);
    }
    if (url.type === 'youtube') {
      this._player = new PlayerYoutube();
      this._player.element(this.id);
      this._player.load(url.id, callback);
    }
    return this._player;
  };

  Player.prototype.finish = function(callback) {
    if (this._player) {
      return this._player.finish(callback);
    }
  };

  Player.prototype.error = function(callback) {
    if (this._player) {
      return this._player.error(callback);
    }
  };

  Player.prototype.play = function() {
    if (this._player) {
      return this._player.play();
    }
  };

  Player.prototype.pause = function() {
    if (this._player) {
      return this._player.pause();
    }
  };

  Player.prototype.stop = function() {
    if (this._player) {
      return this._player.stop();
    }
  };

  Player.prototype.destroy = function() {
    if (this._player) {
      return this._player.destroy();
    }
  };

  return Player;

})(this.PlayerAbstract);