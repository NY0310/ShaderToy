Shader "Hidden/PosTex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" { }
        _Zoom ("Zoom", Range(0.5, 20)) = 1
        _Speed ("Speed", Range(0.01, 10)) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZTest Always
        
        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
            };
            
            struct v2f
            {
                float2 uv: TEXCOORD0;
                float4 vertex: SV_POSITION;
            };
            
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            sampler2D _MainTex;
            half _Zoom;
            half _Speed;
            
            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.vertex.xy / _ScreenParams.xy + float2(_CosTime.x * _Speed, _SinTime.x * _Speed) / _Zoom);
                return col;
            }
            ENDCG
            
        }
    }
}
