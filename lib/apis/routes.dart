const baseUrl =
    "https://firefly-backend-sih24-153569340026.us-central1.run.app/api";

const registerUser = "$baseUrl/user/";
const getUser = "$baseUrl/user/";
String getAllNodesForBuilding(int buildingId) =>
    "$baseUrl/building/$buildingId/node";
const updateUser = "$baseUrl/user/";
const confirmIncident = "$baseUrl/user/incident-confirm";
const getBuildingById = "$baseUrl/building/";
