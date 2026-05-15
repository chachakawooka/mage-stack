---
name: Patch Magento Versions
description: Updates Magento Dockerfile environments across specified branches to their latest available patch releases, commits the changes, creates tags, and pushes to GitHub.
---

# Patching Magento Versions

This skill automates the process of checking for new patch releases of Magento Open Source and updating the corresponding repository branch for each version line (e.g., 2.4.5, 2.4.6).

## Requirements
- GitHub access (ssh/auth) to push commits and tags.
- Adobe Commerce Release Notes page to check for latest patch versions: [Adobe Commerce Versions](https://experienceleague.adobe.com/en/docs/commerce-operations/release/versions)

## Execution Steps

When asked to patch or update Magento versions for one or more branches, follow these steps strictly:

### 1. Fetch Latest Versions
- Retrieve the latest patch suffix for the requested Magento version lines (e.g., `2.4.7` might have a latest patch of `-p9`).
- You must check the [Adobe Commerce Release Page](https://experienceleague.adobe.com/en/docs/commerce-operations/release/versions) to get the most accurate, current patch suffix for each branch.

### 2. Identify the Target Tag
- The convention for tags and image tags in this repository is to replace the `-p` with a `.` separator.
- For example: if the latest version is `2.4.7-p9`, the version tag and Docker image tag will be `2.4.7.9`.

### 3. Process Each Branch
Iterate through the specified branches one by one. For each branch `X.Y.Z`:

1.  **Checkout Branch:**
    ```bash
    git checkout <branch_name>
    ```
2.  **Update `docker/stack/Dockerfile`:**
    Find the line `RUN composer create-project` and update the `magento/project-community-edition:<version>` argument to the new version specifying the patch (e.g., `2.4.7-p9`).
3.  **Update `docker-compose-build.yml`:**
    Find the `app` service and update its `image` reference to use the new Docker tag (e.g., `chachakawooka/mage_stack:2.4.7.9`).
4.  **Update `Dockerfile-dev`:**
    Update the `FROM` declaration to point to the new Docker tag (e.g., `FROM chachakawooka/mage_stack:2.4.7.9`).
5.  **Commit and Tag:**
    Stage the modified files, commit the changes with a descriptive message, and create a tag mirroring the Docker tag.
    ```bash
    git add Dockerfile-dev docker-compose-build.yml docker/stack/Dockerfile
    git commit -m "Update Magento version to <version-pX> and tags to <version>"
    git tag <tag_name>
    ```
6.  **Push:**
    Push the branch and the newly created tag to GitHub.
    ```bash
    git push origin HEAD
    git push origin <tag_name>
    ```

### 4. Verification
- Verify that the tags were pushed to the remote repository successfully.
- Inform the user of the successful updates and new tag mappings.
