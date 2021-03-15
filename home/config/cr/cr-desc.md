### Description
 
<INSERT DETAILS>
 
### Testing and reproduction steps
 
<DESCRIBE TESTING PROCESS>
 
### Checklist
 
#### Front-end
 
* ran `bb release` (or `bb release-police` for HireWebsite) -
* ran `bb acceptance` -
* ran `bb rails` -
* visited website with dev console open to check for errors -
* tested in Chrome, Firefox, Internet Explorer, and Safari -
* tested the performance impact of the code change -
* added UX to reviewers -
* other (specify) -
 
#### Apollo-Back-end
 
* ran Sonar lint in IDE -
* ran unit tests in IDE with code coverage plugin (new code 100%, updated code >=90%) -
* ran `bb release` -
* ran `bb integration` -
* ran `bb server` -
* visited service explorer and ran service calls (specify which) -
* tested the performance impact of the code change -
* other (specify) -
* (ArtRecruitingService only) - are the service calls on the correct schema or transaction type (Read-Only/Read-Write) -
* (microservices only:) updated API wiki page -
* (ArtRecruitingService only - if new call:) This call has to be on ArtRecruitingService because <insert reason here>

#### NAWS-Back-end

* ran Sonar lint in IDE -
* ran `bb release` -
* ran `bb integration` -
* ran unit tests in IDE with code coverage plugin (new code 100%, updated code >=90%) -
* deployed AWS stacks successfully to developer AWS account - 
* confirmed all resources created in AWS - 
* visited API gateway and ran service calls (specify which) - 
* tested the performance impact of the code change - 

#### All CRs
 
* rebased against release branch before posting CR -
* prefaced CR summary with [PackageNameX], [PackageNameY], [...] instead of [X packages] -
* updated SIM task points and set next step to "Review" -
