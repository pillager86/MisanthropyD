module misanthropyd.core.layer;

import misanthropyd.core.timestep;
import misanthropyd.events.event;

/// A layer is a section of the application that receives events and renders
class Layer
{
    /// constructor
    this(const string name)
    {
        debug 
        {
            debugName_ = name;
        }
    }

    /// called when layer is attached to stack
    void onAttach() {}
    /// called when layer is detached from stack
    void onDetach() {}
    /// called when layer is updated each frame
    void onUpdate(const Timestep ts) {}
    /// called when layer receives event
    void onEvent(Event event) {}

    /// debug name property
    pure @safe @nogc string name() const nothrow { return debugName_; }

    protected string debugName_;
}