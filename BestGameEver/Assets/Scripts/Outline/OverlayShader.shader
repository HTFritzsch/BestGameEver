Shader "OverlayShader"
{
    Properties
    {
        Color_4977190d40f54fdbbf20ad3b4760d824("OutlineColor", Color) = (0, 0, 0, 0)
        Vector1_50ec78d588fe460282f7b5101a4013ad("OutlineThickness", Float) = 0.01
        Vector1_6a3988d0fa724509a5acafba71a71827("OutlineDepthStrenght", Float) = 1
        Vector1_e3ae18576f644b298ffd7b781aae7ed4("OutlineDepthTghtening", Float) = 1
        Vector1_b090d9f028af4226baf7acb79df38fb4("OutlineDepthTreshhold", Float) = 1
        Vector1_73dcf17072a1407bbb09a42a7cf70a6e("OutlineAcuteDepthThreshold", Float) = 1
        Vector1_e400af77591c40e3a0fefb881fe1842f("OutlineAcuteStartDot", Float) = 0.9
        Vector1_f2efcf9da0144973978b731a527cb740("OutlineNormalStrenght", Float) = 1
        Vector1_e53a4bd02d714674a0954da299a905c7("OutlineNormalTightening", Float) = 1
        Vector1_24df9ce9ac5d482b85c86aa7787e0ecf("OutlineNormalThreshold", Float) = 1
        Vector1_9fa1aed35c1849c18116a9c15f0d2c50("OutlineFarNormalThreshold", Float) = 1
        Vector1_3bb337f461194e74b01b8d926b12f359("OutlineFarNormalStartDepth", Float) = 1
        Vector1_ae6298819dc4499888705d85b92a4718("OutlineFarNormalEndDepth", Float) = 10
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma shader_feature _ _SAMPLE_GI
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9f80b947728a41408325b974ed3433c6_Out_0 = Color_4977190d40f54fdbbf20ad3b4760d824;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.BaseColor = (_Property_9f80b947728a41408325b974ed3433c6_Out_0.xyz);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 4.5
    #pragma exclude_renderers gles gles3 glcore
    #pragma multi_compile_instancing
    #pragma multi_compile _ DOTS_INSTANCING_ON
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "UniversalMaterialType" = "Unlit"
            "Queue" = "Transparent"
        }
        Pass
        {
            Name "Pass"
            Tags
            {
            // LightMode: <None>
        }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma multi_compile_fog
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
    #pragma multi_compile _ DIRLIGHTMAP_COMBINED
    #pragma shader_feature _ _SAMPLE_GI
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_UNLIT
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float3 BaseColor;
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _Property_9f80b947728a41408325b974ed3433c6_Out_0 = Color_4977190d40f54fdbbf20ad3b4760d824;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.BaseColor = (_Property_9f80b947728a41408325b974ed3433c6_Out_0.xyz);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/UnlitPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "ShadowCaster"
    Tags
    {
        "LightMode" = "ShadowCaster"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthOnly"
    Tags
    {
        "LightMode" = "DepthOnly"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off
    ColorMask 0

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

    ENDHLSL
}
Pass
{
    Name "DepthNormals"
    Tags
    {
        "LightMode" = "DepthNormals"
    }

        // Render State
        Cull Off
    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
    ZTest Always
    ZWrite Off

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        HLSLPROGRAM

        // Pragmas
        #pragma target 2.0
    #pragma only_renderers gles gles3 glcore d3d11
    #pragma multi_compile_instancing
    #pragma vertex vert
    #pragma fragment frag

        // DotsInstancingOptions: <None>
        // HybridV1InjectedBuiltinProperties: <None>

        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALSONLY
    #define REQUIRE_DEPTH_TEXTURE
        /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

        // --------------------------------------------------
        // Structs and Packing

        struct Attributes
    {
        float3 positionOS : POSITION;
        float3 normalOS : NORMAL;
        float4 tangentOS : TANGENT;
        float4 uv1 : TEXCOORD1;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : INSTANCEID_SEMANTIC;
        #endif
    };
    struct Varyings
    {
        float4 positionCS : SV_POSITION;
        float3 positionWS;
        float3 normalWS;
        float4 tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };
    struct SurfaceDescriptionInputs
    {
        float3 WorldSpacePosition;
        float4 ScreenPosition;
    };
    struct VertexDescriptionInputs
    {
        float3 ObjectSpaceNormal;
        float3 ObjectSpaceTangent;
        float3 ObjectSpacePosition;
    };
    struct PackedVaryings
    {
        float4 positionCS : SV_POSITION;
        float3 interp0 : TEXCOORD0;
        float3 interp1 : TEXCOORD1;
        float4 interp2 : TEXCOORD2;
        #if UNITY_ANY_INSTANCING_ENABLED
        uint instanceID : CUSTOM_INSTANCE_ID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
        #endif
    };

        PackedVaryings PackVaryings(Varyings input)
    {
        PackedVaryings output;
        output.positionCS = input.positionCS;
        output.interp0.xyz = input.positionWS;
        output.interp1.xyz = input.normalWS;
        output.interp2.xyzw = input.tangentWS;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }
    Varyings UnpackVaryings(PackedVaryings input)
    {
        Varyings output;
        output.positionCS = input.positionCS;
        output.positionWS = input.interp0.xyz;
        output.normalWS = input.interp1.xyz;
        output.tangentWS = input.interp2.xyzw;
        #if UNITY_ANY_INSTANCING_ENABLED
        output.instanceID = input.instanceID;
        #endif
        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
        #endif
        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        output.cullFace = input.cullFace;
        #endif
        return output;
    }

    // --------------------------------------------------
    // Graph

    // Graph Properties
    CBUFFER_START(UnityPerMaterial)
float4 Color_4977190d40f54fdbbf20ad3b4760d824;
float Vector1_50ec78d588fe460282f7b5101a4013ad;
float Vector1_6a3988d0fa724509a5acafba71a71827;
float Vector1_e3ae18576f644b298ffd7b781aae7ed4;
float Vector1_b090d9f028af4226baf7acb79df38fb4;
float Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
float Vector1_e400af77591c40e3a0fefb881fe1842f;
float Vector1_f2efcf9da0144973978b731a527cb740;
float Vector1_e53a4bd02d714674a0954da299a905c7;
float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
float Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
float Vector1_3bb337f461194e74b01b8d926b12f359;
float Vector1_ae6298819dc4499888705d85b92a4718;
CBUFFER_END

// Object and Global properties

    // Graph Functions

// 9107408f84b5aeebe873bc90e4cb9edb
#include "Assets/Scripts/Outline/OutlinesInclude.hlsl"

void Unity_SceneDepth_Raw_float(float4 UV, out float Out)
{
    Out = SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy);
}

void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
{
    Out = dot(A, B);
}

void Unity_OneMinus_float(float In, out float Out)
{
    Out = 1 - In;
}

void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
{
    Out = smoothstep(Edge1, Edge2, In);
}

void Unity_Lerp_float(float A, float B, float T, out float Out)
{
    Out = lerp(A, B, T);
}

void Unity_Multiply_float(float A, float B, out float Out)
{
    Out = A * B;
}

void Unity_Power_float(float A, float B, out float Out)
{
    Out = pow(A, B);
}

struct Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035
{
};

void SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(float Vector1_df03b1cde4b448d9abc11325ce89fb66, float Vector1_90bf56c973a548ea8dcc630db619f149, float Vector1_0bc6269c64ea41388f0f372a27563826, float Vector1_d2b320253b7541dd9dd432509208cdf8, Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 IN, out float Out_1)
{
    float _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0 = Vector1_90bf56c973a548ea8dcc630db619f149;
    float _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0 = Vector1_df03b1cde4b448d9abc11325ce89fb66;
    float _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3;
    Unity_Smoothstep_float(0, _Property_a98fffbeb47a48d0b1ecfd5626ea39fb_Out_0, _Property_dc10eebf1e884634b1e7b9c0b878cfee_Out_0, _Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3);
    float _Property_5946423f206a495889ba6bdfd0a27f46_Out_0 = Vector1_0bc6269c64ea41388f0f372a27563826;
    float _Power_77f97c68951244fda1dd64358e865198_Out_2;
    Unity_Power_float(_Smoothstep_3a582ac1e0e84d5c95b9769af95c961a_Out_3, _Property_5946423f206a495889ba6bdfd0a27f46_Out_0, _Power_77f97c68951244fda1dd64358e865198_Out_2);
    float _Property_671637ce391f4091ad3c3e14ee46097e_Out_0 = Vector1_d2b320253b7541dd9dd432509208cdf8;
    float _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
    Unity_Multiply_float(_Power_77f97c68951244fda1dd64358e865198_Out_2, _Property_671637ce391f4091ad3c3e14ee46097e_Out_0, _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2);
    Out_1 = _Multiply_4c8697b6145e4f14b9eb4bc891434780_Out_2;
}

void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
{
    Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
}

void Unity_Maximum_float(float A, float B, out float Out)
{
    Out = max(A, B);
}

struct Bindings_OurlineGraph_98ced176f984807439d37c04004078cb
{
};

void SG_OurlineGraph_98ced176f984807439d37c04004078cb(float2 Vector2_4b767af5ee9e467fbc7d23db5332dbe9, float Vector1_50ec78d588fe460282f7b5101a4013ad, float Vector1_6a3988d0fa724509a5acafba71a71827, float Vector1_e3ae18576f644b298ffd7b781aae7ed4, float Vector1_b090d9f028af4226baf7acb79df38fb4, float Vector1_73dcf17072a1407bbb09a42a7cf70a6e, float Vector1_e400af77591c40e3a0fefb881fe1842f, float Vector1_f2efcf9da0144973978b731a527cb740, float Vector1_e53a4bd02d714674a0954da299a905c7, float Vector1_24df9ce9ac5d482b85c86aa7787e0ecf, float Vector1_9fa1aed35c1849c18116a9c15f0d2c50, float Vector1_3bb337f461194e74b01b8d926b12f359, float Vector1_ae6298819dc4499888705d85b92a4718, Bindings_OurlineGraph_98ced176f984807439d37c04004078cb IN, out float Out_1)
{
    float2 _Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2;
    DepthSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2);
    float2 _Property_6fae930afe0646be94902dcc091730cd_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1;
    Unity_SceneDepth_Raw_float((float4(_Property_6fae930afe0646be94902dcc091730cd_Out_0, 0.0, 1.0)), _SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1);
    float _Property_efec62443df841c0a4f4b68bbdcf15db_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_70118eaf443c46d98232001c7c005381_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_e354240019894ea58a03f08e97231d8c_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float2 _Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1;
    float3 _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2;
    CalculateDepthNormal_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1, _CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Normal_2);
    float3 _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2;
    ViewDirectionFromScreenUV_float(_Property_a73a5a0ee5ec40d491e62097bd740c80_Out_0, _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2);
    float _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2;
    Unity_DotProduct_float3((_CalculateDepthNormalCustomFunction_fd94d5e762504f4f801970a419c1e404_Depth_1.xxx), _ViewDirectionFromScreenUVCustomFunction_79936cf7aae14c5e840185a6c94323bd_Out_2, _DotProduct_fabd658e094841089fcd2fb56f547389_Out_2);
    float _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1;
    Unity_OneMinus_float(_DotProduct_fabd658e094841089fcd2fb56f547389_Out_2, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1);
    float _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3;
    Unity_Smoothstep_float(_Property_e354240019894ea58a03f08e97231d8c_Out_0, 1, _OneMinus_22349bc03eae472aaf901ce91e94cc54_Out_1, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3);
    float _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3;
    Unity_Lerp_float(_Property_efec62443df841c0a4f4b68bbdcf15db_Out_0, _Property_70118eaf443c46d98232001c7c005381_Out_0, _Smoothstep_2f31e0215b544bc7a9e42d01ae57f85a_Out_3, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3);
    float _Multiply_4b882502686d4006a73f2b817af283ea_Out_2;
    Unity_Multiply_float(_SceneDepth_2498d5fdc08b4ff0ae16eb33f7c774d6_Out_1, _Lerp_125d750d79c44f1fbf1108008c219caa_Out_3, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2);
    float _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab;
    float _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_DepthSobelCustomFunction_57ff14a8b43d4e80bd3da7028b2ac752_Out_2, _Multiply_4b882502686d4006a73f2b817af283ea_Out_2, _Property_2f976f26e7c843d2b3b29b22015250e0_Out_0, _Property_272ab8f48e5a44adb77ce814a0e5ffd7_Out_0, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab, _SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1);
    float _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2;
    NormalsSobel_float(_Property_4db61fe659d343c8ae0160fc4a1a6d37_Out_0, _Property_07f421969ba04fd28e1a6d35cd0506ed_Out_0, _NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2);
    float _Property_c6d84ba681064c06aa9ed92bb347047a_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_438cc92a42354dddafe6670673296390_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    float2 _Property_816471dc40df4233bd6bc091dd8c8d58_Out_0 = Vector2_4b767af5ee9e467fbc7d23db5332dbe9;
    float _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1;
    Unity_SceneDepth_Eye_float((float4(_Property_816471dc40df4233bd6bc091dd8c8d58_Out_0, 0.0, 1.0)), _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1);
    float _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3;
    Unity_Smoothstep_float(_Property_438cc92a42354dddafe6670673296390_Out_0, _Property_b8e5ef7e442a400bb7128a0aec5cbc44_Out_0, _SceneDepth_3f74dbdf77044aa0bd32ddca2eb3638c_Out_1, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3);
    float _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3;
    Unity_Lerp_float(_Property_c6d84ba681064c06aa9ed92bb347047a_Out_0, _Property_f8d667120a6e4664b9b3cc1e3649eef2_Out_0, _Smoothstep_55d7eae4f5914c57b2ba38e292fbbf65_Out_3, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3);
    float _Property_0d609545eae049d0b1311e118fecff1c_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    Bindings_SobleFineTuning_33c0e130749d6f54097acb01bec4b035 _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f;
    float _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1;
    SG_SobleFineTuning_33c0e130749d6f54097acb01bec4b035(_NormalsSobelCustomFunction_58cca9e06b0f46b295e9ed7db9699fa0_Out_2, _Lerp_d5581f41160345e7af713f63a89cfc46_Out_3, _Property_0d609545eae049d0b1311e118fecff1c_Out_0, _Property_dd43a2e767a64163bd9dc82bceb0ce42_Out_0, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1);
    float _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
    Unity_Maximum_float(_SobleFineTuning_83e4581dc31e473bb6a32fbd8cc7e0ab_Out_1, _SobleFineTuning_418bef39a4d24beaa30ffce678a85f4f_Out_1, _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2);
    Out_1 = _Maximum_0d6b597bd4cb47dfb02d4250e33ff35c_Out_2;
}

// Graph Vertex
struct VertexDescription
{
    float3 Position;
    float3 Normal;
    float3 Tangent;
};

VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
{
    VertexDescription description = (VertexDescription)0;
    description.Position = IN.ObjectSpacePosition;
    description.Normal = IN.ObjectSpaceNormal;
    description.Tangent = IN.ObjectSpaceTangent;
    return description;
}

// Graph Pixel
struct SurfaceDescription
{
    float Alpha;
};

SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
{
    SurfaceDescription surface = (SurfaceDescription)0;
    float4 _ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0 = float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0);
    float _Property_34686365eef04f5ca371510b1e78096c_Out_0 = Vector1_50ec78d588fe460282f7b5101a4013ad;
    float _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0 = Vector1_6a3988d0fa724509a5acafba71a71827;
    float _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0 = Vector1_e3ae18576f644b298ffd7b781aae7ed4;
    float _Property_0f2739c0509847dc84b361392a5b1d58_Out_0 = Vector1_b090d9f028af4226baf7acb79df38fb4;
    float _Property_970add5772164028b222faa976bbc44b_Out_0 = Vector1_73dcf17072a1407bbb09a42a7cf70a6e;
    float _Property_15a8984d30154dafa4382bb2975a2961_Out_0 = Vector1_e400af77591c40e3a0fefb881fe1842f;
    float _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0 = Vector1_f2efcf9da0144973978b731a527cb740;
    float _Property_670c61f21d374ac69be22ef6a3828f03_Out_0 = Vector1_e53a4bd02d714674a0954da299a905c7;
    float _Property_f4360299c9e34cf69148f5257d479460_Out_0 = Vector1_24df9ce9ac5d482b85c86aa7787e0ecf;
    float _Property_889856a296d04e9faba23722bfe17536_Out_0 = Vector1_9fa1aed35c1849c18116a9c15f0d2c50;
    float _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0 = Vector1_3bb337f461194e74b01b8d926b12f359;
    float _Property_cfa9d550a74d42aebd12732418f3f015_Out_0 = Vector1_ae6298819dc4499888705d85b92a4718;
    Bindings_OurlineGraph_98ced176f984807439d37c04004078cb _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25;
    float _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    SG_OurlineGraph_98ced176f984807439d37c04004078cb((_ScreenPosition_849f5df653a341a993f4cacf8fa585f7_Out_0.xy), _Property_34686365eef04f5ca371510b1e78096c_Out_0, _Property_2d847d36bd074c9b86f91cd1ded9a913_Out_0, _Property_02eaa9f9d79548efaadf5f799d6070fe_Out_0, _Property_0f2739c0509847dc84b361392a5b1d58_Out_0, _Property_970add5772164028b222faa976bbc44b_Out_0, _Property_15a8984d30154dafa4382bb2975a2961_Out_0, _Property_e32905a31bbb4a8fa401b26c7c1519b4_Out_0, _Property_670c61f21d374ac69be22ef6a3828f03_Out_0, _Property_f4360299c9e34cf69148f5257d479460_Out_0, _Property_889856a296d04e9faba23722bfe17536_Out_0, _Property_d13a6b3b9d7a4e2f8533dcd936b3f1e9_Out_0, _Property_cfa9d550a74d42aebd12732418f3f015_Out_0, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25, _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1);
    surface.Alpha = _OurlineGraph_efd9a7c32ba24b848d39afeca8f45d25_Out_1;
    return surface;
}

// --------------------------------------------------
// Build Graph Inputs

VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
{
    VertexDescriptionInputs output;
    ZERO_INITIALIZE(VertexDescriptionInputs, output);

    output.ObjectSpaceNormal = input.normalOS;
    output.ObjectSpaceTangent = input.tangentOS.xyz;
    output.ObjectSpacePosition = input.positionOS;

    return output;
}
    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
{
    SurfaceDescriptionInputs output;
    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);





    output.WorldSpacePosition = input.positionWS;
    output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
#if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
#else
#define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
#endif
#undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

    return output;
}

    // --------------------------------------------------
    // Main

    #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

    ENDHLSL
}
    }
        FallBack "Hidden/Shader Graph/FallbackError"
}