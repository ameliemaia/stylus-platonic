var ParticlesView;

ParticlesView = (function() {
  ParticlesView.prototype.particles = 0;

  function ParticlesView() {
    var scene,
      _this = this;
    this.particles = $('.particle').length;
    scene = new PlatonicScene();
    scene.on.ready.addOnce(function() {
      scene.loop();
      scene.scene_stats.add(_this, 'particles');
      return scene.add_ui_controls();
    });
    scene.setup();
  }

  return ParticlesView;

})();

$(function() {
  return new ParticlesView();
});
