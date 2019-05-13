Shader "Custom/Outline Shader"
{
	Properties
	{

	   _Outline("Outline", float) = 0
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			Stencil {
				Ref 4
				Comp always
				Pass replace
				ZFail keep
			}
			Cull Front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			struct appData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			uniform float _Outline;
			v2f vert(appData v)
			{
				v2f o;
				//v.vertex += float4(v.normal, 1.0) * _Outline;
				o.vertex = UnityObjectToClipPos(v.vertex + v.normal * _Outline);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{

				return float4(0, 1, 0, 0);
			}
			ENDCG
		}
		Pass
		{
			Stencil {
				Ref 4
				Comp always
				Pass replace
				ZFail keep
			}
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			struct appData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;

			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			v2f vert(appData v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{

				return float4(0, 0, 0, 0);
			}
			ENDCG
		}
		Pass
		{
			Tags
			{
				"Queue" = "Transparent"
			}

			ZWrite Off
			ZTest Always

			Blend SrcAlpha OneMinusSrcAlpha

			Stencil {
				Ref 3
				Comp Greater
				Fail keep
				Pass replace
			}
			

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			struct appData
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;

			};
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};

			v2f vert(appData v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{

				return float4(1, 1, 0, 0.3);
			}
			ENDCG
		}
	}

		FallBack "Diffuse"
}
