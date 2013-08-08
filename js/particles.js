var ParticlesView;

ParticlesView = (function() {
  ParticlesView.prototype.particles = 0;

  function ParticlesView() {
    this.particles = $('.particle').length;
    window.scene_stats.add(this, 'particles');
    window.PLATONIC_SCENE.add_ui_controls();
  }

  return ParticlesView;

})();

$(function() {
  return new ParticlesView();
});
