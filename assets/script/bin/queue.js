// Generated by CoffeeScript 1.6.2
(function() {
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
      var callback, _i, _len, _ref, _results;

      console.log("add");
      this.songs.push(song);
      if (this.songs.length === 1) {
        this.playing = true;
        this.loadAndPlay();
      }
      _ref = this.callbacks['add'] || [];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        _results.push(callback.call(this, song));
      }
      return _results;
    };

    Queue.prototype.remove = function(index) {
      console.log("remove");
      console.log(index);
      return this.songs.splice(index, 1);
    };

    Queue.prototype.play = function(index) {
      console.log("play");
      if (this.player) {
        this.player.play();
        return this.playing = true;
      }
    };

    Queue.prototype.pause = function() {
      console.log("pause");
      if (this.player) {
        this.player.pause();
        return this.playing = false;
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
      console.log("stop");
      if (this.player) {
        this.player.stop();
        return this.playing = false;
      }
    };

    Queue.prototype.prev = function() {
      console.log("prev");
      if (this.index - 1 >= 0) {
        this.index--;
        return this.loadAndPlay();
      }
    };

    Queue.prototype.next = function() {
      console.log("next");
      if (this.index + 1 < this.songs.length) {
        this.index++;
        return this.loadAndPlay();
      }
    };

    Queue.prototype.load = function() {
      var song,
        _this = this;

      if (this.player) {
        if ((song = this.songs[this.index])) {
          return this.player.load(song.link, function() {
            _this.player.finish(function() {
              return _this.next();
            });
          });
        }
      }
    };

    Queue.prototype.loadAndPlay = function() {
      var song,
        _this = this;

      if (this.player) {
        if ((song = this.songs[this.index])) {
          return this.player.load(song.link, function() {
            _this.player.finish(function() {
              return _this.next();
            });
            if (_this.isPlaying()) {
              return _this.play();
            }
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

}).call(this);
