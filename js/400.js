var View400;

View400 = (function() {
  function View400() {
    var scene,
      _this = this;
    scene = new PlatonicScene({
      rotation_x: -90,
      rotation_y: 45
    });
    scene.on.ready.addOnce(function() {
      scene.add_ui_controls();
      return scene.loop();
    });
    scene.setup();
  }

  return View400;

})();

$(function() {
  return new View400();
});
