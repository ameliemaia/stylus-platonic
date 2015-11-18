var Scene,
  slice = [].slice,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

window.log = (function(_this) {
  return function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return typeof console !== "undefined" && console !== null ? console.log.apply(console, args) : void 0;
  };
})(this);

Scene = (function() {
  Scene.prototype.view = '';

  Scene.prototype.views = ['shapes', 'primitives', 'platonic-solids', 'fractals', 'ui-components', 'particles'];

  Scene.prototype.stats = {
    groups: 0,
    meshes: 0,
    faces: 0,
    photon_shaders: 0,
    ui_components: 0
  };

  function Scene() {
    this._change_view = bind(this._change_view, this);
    this.loop = bind(this.loop, this);
    var gui, i, j, len, ref, scene_stats, view;
    this.$window = $(window);
    ref = this.views;
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      view = ref[i];
      if (window.location.href.match(RegExp("" + view))) {
        this.views.splice(i, 1);
        this.views.unshift(view);
      }
    }
    this.$viewport = $('.platonic-viewport');
    this.$scene = this.$viewport.find('.scene');
    this.light = new Photon.Light();
    this.face_groups = [];
    $('.group:not(.mesh > .group):not([data-light="0"]), .mesh:not(.group > .mesh):not([data-light="0"])').each((function(_this) {
      return function(index, element) {
        var face_group;
        face_group = new Photon.FaceGroup($(element)[0], $(element).find('.face'), 0.8, 0.1, true);
        return _this.face_groups.push(face_group);
      };
    })(this));
    gui = new dat.GUI();
    this.cam = new Camera(this.$viewport, gui);
    this.fps = new Stats();
    this.$viewport.append(this.fps.domElement);
    this.stats.groups = $('.group').length;
    this.stats.meshes = $('.mesh').length;
    this.stats.faces = $('.face').length;
    this.stats.photon_shaders = $('.photon-shader').length;
    this.stats.ui_components = $('.ui-component').length;
    scene_stats = gui.addFolder('Scene');
    scene_stats.add(this, 'view', this.views).onChange((function(_this) {
      return function(value) {
        return _this._change_view(value);
      };
    })(this));
    scene_stats.add(this.stats, 'groups').listen();
    scene_stats.add(this.stats, 'meshes').listen();
    scene_stats.add(this.stats, 'faces').listen();
    scene_stats.add(this.stats, 'photon_shaders').listen();
    scene_stats.add(this.stats, 'ui_components').listen();
    scene_stats.open();
    this.$window.resize((function(_this) {
      return function() {
        return _this.on_resize();
      };
    })(this));
    this.$window.trigger('resize');
    this.loop();
  }

  Scene.prototype.on_resize = function() {
    this.win_width = this.$window.width();
    this.win_height = this.$window.height();
    this.$viewport.css({
      height: this.win_height + 'px'
    });
    this.$scene.css({
      height: this.win_height + 'px'
    });
    return this.cam.resize();
  };

  Scene.prototype.update = function() {
    var face_group, j, len, ref;
    this.fps.begin();
    this.cam.update();
    if (this.face_groups.length > 0) {
      ref = this.face_groups;
      for (j = 0, len = ref.length; j < len; j++) {
        face_group = ref[j];
        face_group.render(this.light, true);
      }
    }
    return this.fps.end();
  };

  Scene.prototype.loop = function() {
    this.update();
    return requestAnimationFrame(this.loop);
  };

  Scene.prototype._change_view = function(view) {
    return window.location = window.location.origin + "/" + view + ".html";
  };

  return Scene;

})();

$(function() {
  var scene;
  return scene = new Scene();
});
