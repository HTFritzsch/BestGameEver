using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ground : MonoBehaviour
{

    [SerializeField] private Renderer meshRenderer;
    [SerializeField] private Collider childCollider;

    [SerializeField] private Material overlayMat;

    
    private void Start()
    {
        RotateRandom();
        childCollider.gameObject.AddComponent<GroundColliderChild>();
        childCollider.GetComponent<GroundColliderChild>().ground = this;
    }

    private void RotateRandom() {
        int randomizer = Random.Range(1, 4);
        gameObject.transform.rotation = Quaternion.Euler(0, 90 * randomizer, 0);
    }

    public void TurnOffOutline() {
        Material[] materials = meshRenderer.materials;
        List<Material> materialList = new List<Material>(meshRenderer.materials);
        materialList.RemoveAt(1);
        meshRenderer.materials = materialList.ToArray();
    }

    public void TurnOnOutline()
    {
        List<Material> materialList = new List<Material>();
        materialList.Add(meshRenderer.materials[0]);
        materialList.Add(overlayMat);
        meshRenderer.materials = materialList.ToArray();
    }

    public class GroundColliderChild : MonoBehaviour
    {
        public Ground ground;

        void OnMouseEnter()
        {
            ground.TurnOnOutline();
        }

        void OnMouseExit()
        {
            ground.TurnOffOutline();
        }
    }


}
