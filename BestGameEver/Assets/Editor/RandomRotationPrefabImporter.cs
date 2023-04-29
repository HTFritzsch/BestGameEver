//using UnityEngine;
//using UnityEditor;

//[CustomEditor(typeof(GameObject))]
//[CanEditMultipleObjects]
//public class RandomRotationPrefabImporter : Editor
//{
//    public override void OnInspectorGUI()
//    {
//        DrawDefaultInspector();

//        GameObject prefab = (GameObject)target;

//        // Check if the GameObject is a prefab
//        if (PrefabUtility.GetPrefabAssetType(prefab) != PrefabAssetType.NotAPrefab)
//        {
//            if (GUILayout.Button("Apply Random Rotation"))
//            {
//                ApplyRandomRotation(prefab);
//            }
//        }
//    }

//    void ApplyRandomRotation(GameObject prefab)
//    {
//        float deg = 0;
//        int randomInt = Random.Range(1, 5);

//        switch (randomInt)
//        {
//            case 1:
//                deg = 0;
//                break;
//            case 2:
//                deg = 90;
//                break;
//            case 3:
//                deg = 180;
//                break;
//            case 4:
//                deg = 270;
//                break;
//        }

//        prefab.transform.rotation = Quaternion.Euler(prefab.transform.rotation.x, deg, prefab.transform.rotation.z);
//    }
//}
