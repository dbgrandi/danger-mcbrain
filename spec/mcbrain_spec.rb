require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerMcBrain do
    it 'should be a plugin' do
      expect(Danger::DangerMcBrain.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @brain = @dangerfile.brain
      end

      it 'should default to a nil namespace' do
        expect(@brain.namespace).to be_nil
      end

      it 'should not use a namespace when it is nil' do
        @brain.namespace = ''
        expect(@brain.send(:real_key, 'asdf')).to eql('asdf')
      end

      it 'should not use a namespace when it is an empty string' do
        @brain.namespace = ''
        expect(@brain.send(:real_key, 'asdf')).to eql('asdf')
      end

      it 'should use namespace as a prefix when available' do
        @brain.namespace = 'pants'
        expect(@brain.send(:real_key, 'asdf')).to eql('pants:asdf')
      end
    end
  end
end
