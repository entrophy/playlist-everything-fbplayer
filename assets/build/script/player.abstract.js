this.PlayerAbstract = (function() {
  function PlayerAbstract() {}

  PlayerAbstract.prototype.element = function(element) {
    throw new Error("element(element): Unimplemented");
  };

  PlayerAbstract.prototype.load = function(url) {
    throw new Error("load(url): Unimplemented");
  };

  PlayerAbstract.prototype.play = function() {
    throw new Error("play(): Unimplemented");
  };

  PlayerAbstract.prototype.pause = function() {
    throw new Error("pause(): Unimplemented");
  };

  PlayerAbstract.prototype.stop = function() {
    throw new Error("stop(): Unimplemented");
  };

  PlayerAbstract.prototype.on = function(event, callback) {
    throw new Error("on(event, callback): Unimplemented");
  };

  PlayerAbstract.prototype.destroy = function() {
    throw new Error("destroy(): Unimplemented");
  };

  return PlayerAbstract;

})();
