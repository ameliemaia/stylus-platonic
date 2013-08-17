var IndexView;

IndexView = (function() {
  function IndexView() {
    var scene,
      _this = this;
    scene = new PlatonicScene();
    scene.on.ready.addOnce(function() {
      return scene.loop();
    });
    scene.setup();
  }

  return IndexView;

})();

$(function() {
  return new IndexView();
});
