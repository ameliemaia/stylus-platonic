var UserInterface,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

UserInterface = (function() {
  /*
  	@private
  */

  /*
  	@public
  */

  UserInterface.prototype.grid = false;

  UserInterface.prototype.display_axis = false;

  UserInterface.prototype.beautify = false;

  /*
  	constructor
  	@param {$element} el
  */


  function UserInterface(el) {
    this.el = el;
    this._toggle_display_axis = __bind(this._toggle_display_axis, this);
    this._toggle_grid = __bind(this._toggle_grid, this);
    this.update = __bind(this.update, this);
    this.$display_axis = this.el.find('.ui-component.display-axis');
    this.$grid = this.el.find('.ui-component.grid');
  }

  UserInterface.prototype.update = function() {
    this._toggle_grid(this.grid);
    return this._toggle_display_axis(this.display_axis);
  };

  UserInterface.prototype._toggle_grid = function(state) {
    if (state) {
      return this.$grid.removeClass('hide');
    } else {
      return this.$grid.addClass('hide');
    }
  };

  UserInterface.prototype._toggle_display_axis = function(state) {
    if (state) {
      return this.$display_axis.removeClass('hide');
    } else {
      return this.$display_axis.addClass('hide');
    }
  };

  return UserInterface;

})();
