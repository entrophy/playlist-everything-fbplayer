var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

this.PlayerYoutube = (function(_super) {
  __extends(PlayerYoutube, _super);

  function PlayerYoutube() {}

  PlayerYoutube.prototype.element = function(id) {
    this.id = id;
  };

  PlayerYoutube.prototype.load = function(url, callback) {
    var _this = this;

    this.create();
    return this._player = new YT.Player('pe-player-youtube', {
      height: '200',
      width: '328',
      videoId: url,
      playerVars: {
        modestbranding: 1,
        controls: 0
      },
      events: {
        onReady: function() {
          return callback();
        },
        onStateChange: function(event) {
          if (event.data === 0 && _this.finishCallback) {
            return _this.finishCallback();
          }
        },
        onError: function(event) {
          if (_this.errorCallback) {
            return _this.errorCallback({
              code: event.data
            });
          }
        }
      }
    });
  };

  PlayerYoutube.prototype.finish = function(callback) {
    console.log("youtube bind finish");
    return this.finishCallback = callback;
  };

  PlayerYoutube.prototype.error = function(callback) {
    return this.errorCallback = callback;
  };

  PlayerYoutube.prototype.play = function() {
    if (this._player) {
      return this._player.playVideo();
    }
  };

  PlayerYoutube.prototype.pause = function() {
    if (this._player) {
      return this._player.pauseVideo();
    }
  };

  PlayerYoutube.prototype.stop = function() {
    if (this._player) {
      return this._player.stopVideo();
    }
  };

  PlayerYoutube.prototype.create = function() {
    var elem;

    elem = $('<div />');
    elem.attr('id', 'pe-player-youtube');
    return $('#' + this.id).append(elem);
  };

  PlayerYoutube.prototype.destroy = function() {
    console.log("youtube destroy");
    return $('#pe-player-youtube').remove();
  };

  return PlayerYoutube;

})(this.PlayerAbstract);
