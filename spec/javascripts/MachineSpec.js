describe("Machine", function() {
  var jQuery = {
    ajax: function(){}
  };

  it("should Ajax fetch a list of modules when constructed", function() {
    spyOn(jQuery, 'ajax');

    var machine = new Machine();

    expect(jQuery.ajax).toHaveBeenCalled();
  });

  describe('instance', function() {
    var machine;
    beforeEach(function() {
      spyOn(jQuery, 'ajax');
      machine = new Machine();
    });

    describe('when receiving module data', function() {
      it('should create empty module instances for each datum');
    });
  });
});