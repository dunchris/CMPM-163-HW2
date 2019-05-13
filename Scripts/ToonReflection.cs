using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ToonReflection : MonoBehaviour
{

    public Shader ToonShader;
    [Range(0.0f, 100.0f)]
    public float BloomFactor;
    private Material screenMat;
    Material ScreenMat
    {
        get
        {
            if (screenMat == null)
            {
                screenMat = new Material(ToonShader);
                screenMat.hideFlags = HideFlags.HideAndDontSave;
            }
            return screenMat;
        }
    }


    void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }

        if (!ToonShader && !ToonShader.isSupported)
        {
            enabled = false;
        }

    }

    void OnRenderImage(RenderTexture sourceTexture, RenderTexture destTexture)
    {
        if (ToonShader != null)
        {

            // Create two temp rendertextures to hold bright pass and blur pass result
            RenderTexture refractPass = RenderTexture.GetTemporary(sourceTexture.width, sourceTexture.height);
            RenderTexture reflectPass = RenderTexture.GetTemporary(sourceTexture.width, sourceTexture.height);
            // Blit using bloom shader pass 0 for bright pass ( Graphics.Blit(SOURCE, DESTINATION, MATERIAL, PASS INDEX);)
            Graphics.Blit(sourceTexture, refractPass, ScreenMat, 0);
            // Blit using bloom shader pass 1 for blur pass ( Graphics.Blit(SOURCE, DESTINATION, MATERIAL, PASS INDEX);)
            Graphics.Blit(sourceTexture, reflectPass, ScreenMat, 1);
            // Set sourceTexture to _BaseTex in the shader
            ScreenMat.SetTexture("_BaseTex", sourceTexture);
            // Blit using bloom shader pass 2 for combine pass ( Graphics.Blit(SOURCE, DESTINATION, MATERIAL, PASS INDEX);)
            Graphics.Blit(sourceTexture, destTexture, ScreenMat, 2);
            // Release both temp rendertextures
            RenderTexture.ReleaseTemporary(refractPass);
            RenderTexture.ReleaseTemporary(reflectPass);
        }
        else
        {
            Graphics.Blit(sourceTexture, destTexture);
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

    void OnDisable()
    {
        if (screenMat)
        {
            DestroyImmediate(screenMat);
        }
    }
}

