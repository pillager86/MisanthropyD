module misanthropyd.core.layerstack;

import std.algorithm: remove;

import misanthropyd.core.layer;

/// implements a stack of Layers
class LayerStack
{
    /// push a layer on to stack before overlays
    void pushLayer(Layer layer) 
    {
        layers_ = layers_[0..layerInsert_] ~ layer ~ layers_[layerInsert_..$];
        ++layerInsert_;
        layer.onAttach();
    }

    /// push overlay to top of stack
    void pushOverlay(Layer overlay) 
    {
        layers_ = layers_ ~ overlay;
        overlay.onAttach();
    }

    /// remove a specified layer
    void popLayer(Layer layer) 
    {
        for(size_t i=0; i < layers_.length; ++i)
        {
            if(layers_[i] is layer)
            {
                layers_[i].onDetach();
                layers_ = layers_.remove(i);
                --layerInsert_;
                break;
            }
        }
    }

    /// remove specified overlay
    void popOverlay(Layer overlay) 
    {
        for(size_t i=0; i < layers_.length; ++i)
        {
            if(layers_[i] is overlay)
            {
                layers_[i].onDetach();
                layers_ = layers_.remove(i);
                break;
            }
        }
    }

    /// for now just return this because range implementation is too complicated
    pure @safe @nogc Layer[] layers() nothrow { return layers_; }

    private 
    {
        Layer[] layers_;
        size_t layerInsert_;
    }
}

unittest
{
    auto stack = new LayerStack();
    auto test = new Layer("testlayer");
    auto overlay = new Layer("testoverlay");
    stack.pushOverlay(overlay);
    stack.pushLayer(test);
    stack.popOverlay(overlay);
    stack.popLayer(test);
}