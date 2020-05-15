module misanthropyd.renderer.renderer2d;

import gfm.math.matrix;
import gfm.math.vector;

import misanthropyd.renderer.buffers;
import misanthropyd.renderer.cameras;
import misanthropyd.renderer.rendercommand;
import misanthropyd.renderer.shaders;
import misanthropyd.renderer.textures;
import misanthropyd.renderer.vertexarray;
import misanthropyd.debugging.instrumentor;

private struct QuadVertex
{
	vec3f position;
	vec4f color;
	vec2f texCoord;
	float texIndex;
	float tilingFactor;
}

private struct Render2DData
{
	static immutable uint MAX_QUADS = 20_000;
	static immutable uint MAX_VERTICES = MAX_QUADS * 4;
	static immutable uint MAX_INDICES = MAX_QUADS * 6;
	static immutable uint MAX_TEXTURE_SLOTS = 32; // To do: render caps

	VertexArray quadVertexArray;
	VertexBuffer quadVertexBuffer;
	Program textureProgram;
	Texture2D whiteTexture;

	uint quadIndexCount = 0;
	QuadVertex[] quadVertexBufferBase;
	uint quadVertexBufferPtr;

	Texture2D[MAX_TEXTURE_SLOTS] textureSlots;
	uint textureSlotIndex = 1; // 0 is white texture

	vec4f[4] quadVertexPositions;
}

private pure @safe @nogc float degreesToRadians(float angle) nothrow
{
	import std.math: PI;
	return angle * PI / 180.0f;
}

private Render2DData render2Ddata;
private ProgramLibrary programLibrary;

/// Renders 2D quads
class Renderer2D 
{
	/// initialization
	static void initialize()
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));
		render2Ddata.quadVertexArray = VertexArray.create();
		render2Ddata.quadVertexBuffer = VertexBuffer.create(render2Ddata.MAX_VERTICES * QuadVertex.sizeof);
		render2Ddata.quadVertexBuffer
			.describeLayout(typeid(float), 3, false, "a_position", QuadVertex.sizeof)
			.describeLayout(typeid(float), 4, true,  "a_color", QuadVertex.sizeof)
			.describeLayout(typeid(float), 2, false, "a_texCoord", QuadVertex.sizeof)
			.describeLayout(typeid(float), 1, false, "a_texIndex", QuadVertex.sizeof)
			.describeLayout(typeid(float), 1, false, "a_tilingFactor", QuadVertex.sizeof);
		render2Ddata.quadVertexArray.addVertexBuffer(render2Ddata.quadVertexBuffer);
		render2Ddata.quadVertexBufferBase = new QuadVertex[render2Ddata.MAX_VERTICES];
		uint[] quadIndices = new uint[render2Ddata.MAX_INDICES];
		uint offset = 0;
		for(uint i=0; i < render2Ddata.MAX_INDICES; i += 6)
		{
			quadIndices[i + 0] = offset + 0;
			quadIndices[i + 1] = offset + 1;
			quadIndices[i + 2] = offset + 2;
			quadIndices[i + 3] = offset + 2;
			quadIndices[i + 4] = offset + 3;
			quadIndices[i + 5] = offset + 0;
			offset += 4;
		}

		IndexBuffer quadIB = IndexBuffer.create(quadIndices);
		render2Ddata.quadVertexArray.setIndexBuffer(quadIB);

		render2Ddata.whiteTexture = Texture2D.create(1, 1);
		immutable ubyte[4] whiteTextureData = [0xFF, 0xFF, 0xFF, 0xFF];
		render2Ddata.whiteTexture.setData(whiteTextureData);

		int[render2Ddata.MAX_TEXTURE_SLOTS] samplers;
		for(uint i=0; i < render2Ddata.MAX_TEXTURE_SLOTS; ++i)
		{
			samplers[i] = i;
		}

		programLibrary = new ProgramLibrary;
		render2Ddata.textureProgram = programLibrary.load("texture", "res/shaders/glsl");
		render2Ddata.textureProgram.use();
		render2Ddata.textureProgram.setIntArray("u_textures", samplers);

		// set texture slot 0 to white
		render2Ddata.textureSlots[0] = render2Ddata.whiteTexture;

		render2Ddata.quadVertexPositions[0] = vec4f(-0.5f, -0.5f, 0.0f, 1.0f);
		render2Ddata.quadVertexPositions[1] = vec4f( 0.5f, -0.5f, 0.0f, 1.0f);
		render2Ddata.quadVertexPositions[2] = vec4f( 0.5f,  0.5f, 0.0f, 1.0f);
		render2Ddata.quadVertexPositions[3] = vec4f(-0.5f,  0.5f, 0.0f, 1.0f);
	}

	/// cleanup
	static void shutdown()
	{

	}

	/// begins a scene
	static void beginScene(const OrthographicCamera camera)
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		render2Ddata.textureProgram.use();
		render2Ddata.textureProgram.setMat4("u_viewProjection", camera.viewProjectionCache);

		render2Ddata.quadIndexCount = 0;
		render2Ddata.quadVertexBufferPtr = 0;

		render2Ddata.textureSlotIndex = 1; // 0 is white so start at 1
	}

	/// ends a scene
	static void endScene()
	{
		mixin(MdProfileScope!(__FUNCTION__));

		ubyte[] data = cast(ubyte[])(render2Ddata.quadVertexBufferBase[0 .. render2Ddata.quadVertexBufferPtr]);
		render2Ddata.quadVertexBuffer.setData(data);
		flush();
	}

	/// flush the draw buffer
	static void flush()
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		for(uint i=0; i < render2Ddata.textureSlotIndex; ++i)
		{
			render2Ddata.textureSlots[i].bind(i);
		}
		RenderCommand.drawIndexed(render2Ddata.quadVertexArray, render2Ddata.quadIndexCount);
	}
	
	/// draws a colored quad
	static void drawQuad(const vec2f position, const vec2f size, const vec4f color)
	{
		drawQuad(vec3f(position.x, position.y, 0.0f), size, color);
	}

	/// draws a colored quad with z index
	static void drawQuad(const vec3f position, const vec2f size, const vec4f color)
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		immutable size_t QUAD_VERTEX_COUNT = 4;
		immutable int TEXTURE_INDEX = 0; // white texture
		immutable vec2f[] TEXTURE_COORDS = [ 
			vec2f(0.0f, 0.0f),
			vec2f(1.0f, 0.0f),
			vec2f(1.0f, 1.0f),
			vec2f(0.0f, 1.0f)
		];
		immutable float TILING_FACTOR = 1.0f;
		if(render2Ddata.quadIndexCount >= render2Ddata.MAX_INDICES)
			flushAndReset();
		immutable mat4x4f TRANSFORM = mat4x4f.translation(position) * mat4x4f.scaling(vec3f(size.x, size.y, 1.0f));
		for(size_t i = 0; i < QUAD_VERTEX_COUNT; ++i)
		{
			immutable pos = TRANSFORM * render2Ddata.quadVertexPositions[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].position =
				vec3f(pos.x, pos.y, pos.z);
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].color = color;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texCoord = TEXTURE_COORDS[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texIndex = TEXTURE_INDEX;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].tilingFactor = TILING_FACTOR;
			++render2Ddata.quadVertexBufferPtr;
		}
		render2Ddata.quadIndexCount += 6;
	}

	/// draws a colored textured quad
	static void drawQuad(const vec2f position, const vec2f size, Texture2D texture, float tilingFactor = 1.0f,
						 const vec4f tintColor = vec4f(1.0f, 1.0f, 1.0f, 1.0f))
	{
		drawQuad(vec3f(position.x, position.y, 0.0f), size, texture, tilingFactor, tintColor);
	}

	/// draws a colored textured quad with z index
	static void drawQuad(const vec3f position, const vec2f size, Texture2D texture, float tilingFactor = 1.0f,
						 const vec4f tintColor = vec4f(1.0f, 1.0f, 1.0f, 1.0f))
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		immutable size_t QUAD_VERTEX_COUNT = 4;
		immutable vec4f COLOR = vec4f(1.0f, 1.0f, 1.0f, 1.0f);
		immutable vec2f[] TEXTURE_COORDS = [ 
			vec2f(0.0f, 0.0f),
			vec2f(1.0f, 0.0f),
			vec2f(1.0f, 1.0f),
			vec2f(0.0f, 1.0f)
		];

		if(render2Ddata.quadIndexCount >= render2Ddata.MAX_INDICES)
			flushAndReset();
		
		int textureIndex = 0;
		for(uint i = 1; i < render2Ddata.textureSlotIndex; ++i)
		{
			if(render2Ddata.textureSlots[i] is texture)
			{
				textureIndex = i;
				break;
			}
		}
		if(textureIndex == 0)
		{
			if(render2Ddata.textureSlotIndex >= render2Ddata.MAX_TEXTURE_SLOTS)
				flushAndReset();
			
			textureIndex = render2Ddata.textureSlotIndex;
			render2Ddata.textureSlots[render2Ddata.textureSlotIndex] = texture;
			++render2Ddata.textureSlotIndex;
		}

		immutable mat4x4f TRANSFORM = mat4x4f.translation(position) * mat4x4f.scaling(vec3f(size.x, size.y, 1.0f));

		for(size_t i=0; i < QUAD_VERTEX_COUNT; ++i)
		{
			immutable pos = TRANSFORM * render2Ddata.quadVertexPositions[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].position =
				vec3f(pos.x, pos.y, pos.z);
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].color = COLOR;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texCoord = TEXTURE_COORDS[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texIndex = textureIndex;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].tilingFactor = tilingFactor;
			++render2Ddata.quadVertexBufferPtr;
		}

		render2Ddata.quadIndexCount += 6;
	}

	/// draw rotated quad with color
	static void drawRotatedQuad(const vec2f position, const vec2f size, const float rotation, const vec4f color)
	{
		drawRotatedQuad(vec3f(position.x, position.y, 0.0f), size, rotation, color);

	}

	/// draw rotated quad with color at z index
	static void drawRotatedQuad(const vec3f position, const vec2f size, const float rotation, const vec4f color)
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		immutable size_t QUAD_VERTEX_COUNT = 4;
		immutable int TEXTURE_INDEX = 0; // white texture
		immutable vec2f[] TEXTURE_COORDS = [ 
			vec2f(0.0f, 0.0f),
			vec2f(1.0f, 0.0f),
			vec2f(1.0f, 1.0f),
			vec2f(0.0f, 1.0f)
		];
		immutable float TILING_FACTOR = 1.0f;

		if(render2Ddata.quadIndexCount >= render2Ddata.MAX_INDICES)
			flushAndReset();

		immutable mat4x4f TRANSFORM = mat4x4f.translation(position)
			* mat4x4f.rotation(degreesToRadians(rotation), vec3f(0.0f, 0.0f, 1.0f))
			* mat4x4f.scaling(vec3f(size.x, size.y, 1.0f));
		
		for(size_t i=0; i < QUAD_VERTEX_COUNT; ++i)
		{
			immutable pos = TRANSFORM * render2Ddata.quadVertexPositions[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].position =
				vec3f(pos.x, pos.y, pos.z);
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].color = color;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texCoord = TEXTURE_COORDS[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texIndex = TEXTURE_INDEX;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].tilingFactor = TILING_FACTOR;
			++render2Ddata.quadVertexBufferPtr;           
		}

		render2Ddata.quadIndexCount += 6;
	}

	/// draw rotated quad with texture
	static void drawRotatedQuad(const vec2f position, const vec2f size, const float rotation, Texture2D texture, 
								float tilingFactor = 1.0f, const vec4f tintColor = vec4f( 1.0f, 1.0f, 1.0f, 1.0f))
	{
		drawRotatedQuad(vec3f(position.x, position.y, 0.0f), size, rotation, texture, tilingFactor, tintColor);
	}

	/// draw rotated quad with texture at z index
	static void drawRotatedQuad(const vec3f position, const vec2f size, const float rotation, Texture2D texture, 
								float tilingFactor = 1.0f, const vec4f tintColor = vec4f( 1.0f, 1.0f, 1.0f, 1.0f))
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		immutable size_t QUAD_VERTEX_COUNT = 4;
		immutable vec4f COLOR = vec4f(1.0f, 1.0f, 1.0f, 1.0f);
		immutable vec2f[] TEXTURE_COORDS = [ 
			vec2f(0.0f, 0.0f),
			vec2f(1.0f, 0.0f),
			vec2f(1.0f, 1.0f),
			vec2f(0.0f, 1.0f)
		];

		if(render2Ddata.quadIndexCount >= render2Ddata.MAX_INDICES)
			flushAndReset();
		
		int textureIndex = 0;
		for(uint i = 1; i < render2Ddata.textureSlotIndex; ++i)
		{
			if(render2Ddata.textureSlots[i] is texture)
			{
				textureIndex = i;
				break;
			}
		}
		if(textureIndex == 0)
		{
			if(render2Ddata.textureSlotIndex >= render2Ddata.MAX_TEXTURE_SLOTS)
				flushAndReset();
			
			textureIndex = render2Ddata.textureSlotIndex;
			render2Ddata.textureSlots[render2Ddata.textureSlotIndex] = texture;
			++render2Ddata.textureSlotIndex;
		}

		immutable mat4x4f TRANSFORM = mat4x4f.translation(position)
				* mat4x4f.rotation(degreesToRadians(rotation), vec3f(0.0f, 0.0f, 1.0f))
				* mat4x4f.scaling(vec3f(size.x, size.y, 1.0f));

		for(size_t i=0; i < QUAD_VERTEX_COUNT; ++i)
		{
			immutable pos = TRANSFORM * render2Ddata.quadVertexPositions[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].position =
				vec3f(pos.x, pos.y, pos.z);
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].color = COLOR;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texCoord = TEXTURE_COORDS[i];
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].texIndex = textureIndex;
			render2Ddata.quadVertexBufferBase[render2Ddata.quadVertexBufferPtr].tilingFactor = tilingFactor;
			++render2Ddata.quadVertexBufferPtr;
		}

		render2Ddata.quadIndexCount += 6;        
	}

	private static void flushAndReset()
	{
		mixin(MdProfileScope!(__PRETTY_FUNCTION__));

		endScene();
		render2Ddata.quadIndexCount = 0;
		render2Ddata.quadVertexBufferPtr = 0;
		render2Ddata.textureSlotIndex = 1;
	}
}