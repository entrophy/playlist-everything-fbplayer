this.Queue = (function() {
  function Queue() {
    var player;

    this.songs = [];
    this.callbacks = [];
    this.index = 0;
    this.playing = false;
    player = new window.Player();
    player.element('player');
    this.player = player;
  }

  Queue.prototype.add = function(song) {
    this.songs.push(song);
    if (this.songs.length === 1) {
      this.playing = true;
      this.loadAndPlay();
    }
    return this.emit('add', [song]);
  };

  Queue.prototype.removeByIndex = function(index) {
    console.log(index);
    return this.songs.splice(index, 1);
  };

  Queue.prototype.play = function() {
    this.playing = true;
    if (this.player) {
      return this.player.play();
    }
  };

  Queue.prototype.playByIndex = function(index) {
    this.stop();
    this.index = index;
    this.emit('change', [this.index]);
    this.playing = true;
    return this.loadAndPlay();
  };

  Queue.prototype.pause = function() {
    this.playing = false;
    if (this.player) {
      return this.player.pause();
    }
  };

  Queue.prototype.playOrPause = function() {
    if (this.player) {
      if (this.isPlaying()) {
        return this.pause();
      } else {
        return this.play();
      }
    }
  };

  Queue.prototype.stop = function() {
    this.playing = false;
    if (this.player) {
      return this.player.stop();
    }
  };

  Queue.prototype.prev = function() {
    if (this.index - 1 >= 0) {
      this.index--;
      this.emit('change', [this.index]);
      return this.loadAndPlay();
    }
  };

  Queue.prototype.next = function() {
    if (this.index + 1 < this.songs.length) {
      this.index++;
      this.emit('change', [this.index]);
      return this.loadAndPlay();
    }
  };

  Queue.prototype.load = function() {
    var player, song,
      _this = this;

    if (this.player) {
      if ((song = this.songs[this.index])) {
        player = this.player.load(song.link, function() {
          _this.player.finish(function() {
            return _this.next();
          });
          if (_this.index === _this.songs.length - 1) {
            _this.emit('last');
          }
        });
        return player.error(function(error) {
          return _this.next();
        });
      }
    }
  };

  Queue.prototype.loadAndPlay = function() {
    var player, song,
      _this = this;

    if (this.player) {
      if ((song = this.songs[this.index])) {
        player = this.player.load(song.link, function() {
          _this.player.finish(function() {
            return _this.next();
          });
          if (_this.isPlaying()) {
            _this.play();
          }
          if (_this.index === _this.songs.length - 1) {
            return _this.emit('last');
          }
        });
        return player.error(function(error) {
          return _this.next();
        });
      }
    }
  };

  Queue.prototype.isPlaying = function() {
    return this.playing;
  };

  Queue.prototype.on = function(event, callback) {
    return (this.callbacks[event] = this.callbacks[event] || []).push(callback);
  };

  Queue.prototype.emit = function(event, args) {
    var callback, _i, _len, _ref, _results;

    if (args == null) {
      args = [];
    }
    _ref = this.callbacks[event] || [];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      callback = _ref[_i];
      _results.push(callback.apply(this, args));
    }
    return _results;
  };

  Queue.prototype.getAllSongs = function() {
    return this.songs;
  };

  Queue.prototype.clear = function() {
    this.removeAll();
    if (this.player) {
      return this.player.destroy();
    }
  };

  Queue.prototype.removeAll = function() {
    if (this.player) {
      this.stop();
    }
    return this.songs.length = 0;
  };

  return Queue;

})();
