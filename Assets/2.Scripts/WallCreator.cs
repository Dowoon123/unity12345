using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WallCreator : MonoBehaviour
{
    // Start is called before the first frame update

    public GameObject Wall_HologramPrefab;
    public GameObject Wall_01Prefab;

    private GameObject Wall_Hologram;
    private GameObject Wall_01;

    private int FloorLayerMask;
    private int FloorLayer;

    private bool bBuild = false;
    void Start()
    {
        FloorLayer = LayerMask.NameToLayer("Floor");
        FloorLayerMask = 1 << FloorLayer;
    }

    // Update is called once per frame
    void Update()
    {

        if (bBuild)
        {
            BuildWall();
        }

    }

    void BuildWall()
    {
        RaycastHit hit;

        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);


        if (Physics.Raycast(ray, out hit, 1000, FloorLayerMask))
        {
            var pos = hit.point;
            pos.y += Wall_Hologram.transform.localScale.y / 2;
            Wall_Hologram.transform.position = pos;

            if (Input.GetMouseButtonDown(0))
            {
                Debug.Log("클릭됨" +  hit.point);
            }

        }

    }

  public void CreateWall()
    {
      Wall_Hologram =  Instantiate(Wall_HologramPrefab, 
          new Vector3(33, 333, 333), Quaternion.Euler(0, 0, 0));
      Wall_01 =   Instantiate(Wall_HologramPrefab,
          new Vector3(33, 333, 333), Quaternion.Euler(0, 0, 0));

        bBuild = true;
    }
}
