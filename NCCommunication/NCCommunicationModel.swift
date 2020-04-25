//
//  NCCommunicationModel.swift
//  Nextcloud
//
//  Created by Marino Faggiana on 12/10/19.
//  Copyright © 2018 Marino Faggiana. All rights reserved.
//
//  Author Marino Faggiana <marino.faggiana@nextcloud.com>
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import MobileCoreServices
import SwiftyXMLParser

//MARK: - File

@objc public class NCFile: NSObject {
    
    @objc public var commentsUnread: Bool = false
    @objc public var contentType = ""
    @objc public var creationDate = NSDate()
    @objc public var date = NSDate()
    @objc public var directory: Bool = false
    @objc public var e2eEncrypted: Bool = false
    @objc public var etag = ""
    @objc public var favorite: Bool = false
    @objc public var fileId = ""
    @objc public var fileName = ""
    @objc public var iconName = ""
    @objc public var hasPreview: Bool = false
    @objc public var mountType = ""
    @objc public var ocId = ""
    @objc public var ownerId = ""
    @objc public var ownerDisplayName = ""
    @objc public var path = ""
    @objc public var permissions = ""
    @objc public var quotaUsedBytes: Double = 0
    @objc public var quotaAvailableBytes: Double = 0
    @objc public var resourceType = ""
    @objc public var richWorkspace = ""
    @objc public var size: Double = 0
    @objc public var serverUrl = ""
    @objc public var trashbinFileName = ""
    @objc public var trashbinOriginalLocation = ""
    @objc public var trashbinDeletionTime = NSDate()
    @objc public var typeFile = ""
}

@objc public class NCExternalFile: NSObject {
    
    @objc public var idExternalSite: Int = 0
    @objc public var name = ""
    @objc public var url = ""
    @objc public var lang = ""
    @objc public var icon = ""
    @objc public var type = ""
}

@objc public class NCEditorDetailsEditors: NSObject {
    
    @objc public var mimetypes = [String]()
    @objc public var name = ""
    @objc public var optionalMimetypes = [String]()
    @objc public var secure: Int = 0
}

@objc public class NCEditorDetailsCreators: NSObject {
    
    @objc public var editor = ""
    @objc public var ext = ""
    @objc public var identifier = ""
    @objc public var mimetype = ""
    @objc public var name = ""
    @objc public var templates: Int = 0
}

@objc public class NCEditorTemplates: NSObject {
    
    @objc public var identifier = ""
    @objc public var delete = ""
    @objc public var ext = ""
    @objc public var name = ""
    @objc public var preview = ""
    @objc public var type = ""
}

//MARK: -

enum typeFile: String {
    case audio = "audio"
    case compress = "compress"
    case directory = "directory"
    case document = "document"
    case image = "image"
    case imagemeter = "imagemeter"
    case unknow = "unknow"
    case video = "video"
}

enum iconName: String {
    case audio = "file_audio"
    case code = "file_code"
    case compress = "file_compress"
    case directory = "directory"
    case document = "document"
    case image = "file_photo"
    case imagemeter = "imagemeter"
    case movie = "file_movie"
    case pdf = "file_pdf"
    case ppt = "file_ppt"
    case txt = "file_txt"
    case unknow = "file"
    case xls = "file_xls"
}

//MARK: - Data File

class NCDataFileXML: NSObject {

    let requestBodyFile =
    """
    <?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <d:propfind xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\" xmlns:nc=\"http://nextcloud.org/ns\">
        <d:prop>
            <d:getlastmodified />
            <d:getetag />
            <d:getcontenttype />
            <d:resourcetype />
            <d:quota-available-bytes />
            <d:quota-used-bytes />
            <d:creationdate />

            <permissions xmlns=\"http://owncloud.org/ns\"/>
            <id xmlns=\"http://owncloud.org/ns\"/>
            <fileid xmlns=\"http://owncloud.org/ns\"/>
            <size xmlns=\"http://owncloud.org/ns\"/>
            <favorite xmlns=\"http://owncloud.org/ns\"/>
            <share-types xmlns=\"http://owncloud.org/ns\"/>
            <owner-id xmlns=\"http://owncloud.org/ns\"/>
            <owner-display-name xmlns=\"http://owncloud.org/ns\"/>
            <comments-unread xmlns=\"http://owncloud.org/ns\"/>

            <is-encrypted xmlns=\"http://nextcloud.org/ns\"/>
            <has-preview xmlns=\"http://nextcloud.org/ns\"/>
            <mount-type xmlns=\"http://nextcloud.org/ns\"/>
            <rich-workspace xmlns=\"http://nextcloud.org/ns\"/>
        </d:prop>
    </d:propfind>
    """
    
    let requestBodyFileSetFavorite =
    """
    <?xml version=\"1.0\"?>
    <d:propertyupdate xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\">
        <d:set>
            <d:prop>
                <oc:favorite>%i</oc:favorite>
            </d:prop>
        </d:set>
    </d:propertyupdate>
    """
    
    let requestBodyFileListingFavorites =
    """
    <?xml version=\"1.0\"?>
    <oc:filter-files xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\" xmlns:nc=\"http://nextcloud.org/ns\">
        <d:prop>
            <d:getlastmodified />
            <d:getetag />
            <d:getcontenttype />
            <d:resourcetype />
            <d:quota-available-bytes />
            <d:quota-used-bytes />
            <d:creationdate />

            <permissions xmlns=\"http://owncloud.org/ns\"/>
            <id xmlns=\"http://owncloud.org/ns\"/>
            <fileid xmlns=\"http://owncloud.org/ns\"/>
            <size xmlns=\"http://owncloud.org/ns\"/>
            <favorite xmlns=\"http://owncloud.org/ns\"/>
            <share-types xmlns=\"http://owncloud.org/ns\"/>
            <owner-id xmlns=\"http://owncloud.org/ns\"/>
            <owner-display-name xmlns=\"http://owncloud.org/ns\"/>
            <comments-unread xmlns=\"http://owncloud.org/ns\"/>

            <is-encrypted xmlns=\"http://nextcloud.org/ns\"/>
            <has-preview xmlns=\"http://nextcloud.org/ns\"/>
            <mount-type xmlns=\"http://nextcloud.org/ns\"/>
            <rich-workspace xmlns=\"http://nextcloud.org/ns\"/>
        </d:prop>
        <oc:filter-rules>
            <oc:favorite>1</oc:favorite>
        </oc:filter-rules>
    </oc:filter-files>
    """
    
    let requestBodySearchFileName =
    """
    <?xml version=\"1.0\"?>
    <d:searchrequest xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\" xmlns:nc=\"http://nextcloud.org/ns\">
    <d:basicsearch>
        <d:select>
            <d:prop>
                <d:displayname/>
                <d:getcontenttype/>
                <d:resourcetype/>
                <d:getcontentlength/>
                <d:getlastmodified/>
                <d:creationdate/>
                <d:getetag/>
                <d:quota-used-bytes/>
                <d:quota-available-bytes/>
                <permissions xmlns=\"http://owncloud.org/ns\"/>
                <id xmlns=\"http://owncloud.org/ns\"/>
                <fileid xmlns=\"http://owncloud.org/ns\"/>
                <size xmlns=\"http://owncloud.org/ns\"/>
                <favorite xmlns=\"http://owncloud.org/ns\"/>
                <is-encrypted xmlns=\"http://nextcloud.org/ns\"/>
                <mount-type xmlns=\"http://nextcloud.org/ns\"/>
                <owner-id xmlns=\"http://owncloud.org/ns\"/>
                <owner-display-name xmlns=\"http://owncloud.org/ns\"/>
                <comments-unread xmlns=\"http://owncloud.org/ns\"/>
                <has-preview xmlns=\"http://nextcloud.org/ns\"/>
                <trashbin-filename xmlns=\"http://nextcloud.org/ns\"/>
                <trashbin-original-location xmlns=\"http://nextcloud.org/ns\"/>
                <trashbin-deletion-time xmlns=\"http://nextcloud.org/ns\"/>
            </d:prop>
        </d:select>
    <d:from>
        <d:scope>
            <d:href>%@</d:href>
            <d:depth>%@</d:depth>
        </d:scope>
    </d:from>
    <d:where>
        <d:like>
            <d:prop>
                <d:displayname/>
            </d:prop>
            <d:literal>%@</d:literal>
        </d:like>
    </d:where>
    </d:basicsearch>
    </d:searchrequest>
    """
    
    let requestBodySearchMedia =
    """
    <?xml version=\"1.0\"?>
    <d:searchrequest xmlns:d=\"DAV:\" xmlns:oc=\"http://owncloud.org/ns\" xmlns:nc=\"http://nextcloud.org/ns\">
      <d:basicsearch>
        <d:select>
          <d:prop>
            <d:displayname/>
            <d:getcontenttype/>
            <d:resourcetype/>
            <d:getcontentlength/>
            <d:getlastmodified/>
            <d:creationdate/>
            <d:getetag/>
            <d:quota-used-bytes/>
            <d:quota-available-bytes/>
            <permissions xmlns=\"http://owncloud.org/ns\"/>
            <id xmlns=\"http://owncloud.org/ns\"/>
            <fileid xmlns=\"http://owncloud.org/ns\"/>
            <size xmlns=\"http://owncloud.org/ns\"/>
            <favorite xmlns=\"http://owncloud.org/ns\"/>
            <is-encrypted xmlns=\"http://nextcloud.org/ns\"/>
            <mount-type xmlns=\"http://nextcloud.org/ns\"/>
            <owner-id xmlns=\"http://owncloud.org/ns\"/>
            <owner-display-name xmlns=\"http://owncloud.org/ns\"/>
            <comments-unread xmlns=\"http://owncloud.org/ns\"/>
            <has-preview xmlns=\"http://nextcloud.org/ns\"/>
            <trashbin-filename xmlns=\"http://nextcloud.org/ns\"/>
            <trashbin-original-location xmlns=\"http://nextcloud.org/ns\"/>
            <trashbin-deletion-time xmlns=\"http://nextcloud.org/ns\"/>
          </d:prop>
        </d:select>
        <d:from>
          <d:scope>
            <d:href>%@</d:href>
            <d:depth>infinity</d:depth>
          </d:scope>
        </d:from>
        <d:orderby>
          <d:order>
            <d:prop>
              <d:getlastmodified/>
            </d:prop>
            <d:descending/>
          </d:order>
          <d:order>
            <d:prop>
              <d:displayname/>
            </d:prop>
            <d:descending/>
          </d:order>
        </d:orderby>
        <d:where>
          <d:and>
            <d:or>
              <d:like>
                <d:prop>
                  <d:getcontenttype/>
                </d:prop>
                <d:literal>image/%%</d:literal>
              </d:like>
              <d:like>
                <d:prop>
                  <d:getcontenttype/>
                </d:prop>
                <d:literal>video/%%</d:literal>
              </d:like>
            </d:or>
            <d:or>
              <d:and>
                <d:lte>
                  <d:prop>
                    <d:getlastmodified/>
                  </d:prop>
                  <d:literal>%@</d:literal>
                </d:lte>
                <d:gte>
                  <d:prop>
                    <d:getlastmodified/>
                  </d:prop>
                  <d:literal>%@</d:literal>
                </d:gte>
              </d:and>
            </d:or>
          </d:and>
        </d:where>
      </d:basicsearch>
    </d:searchrequest>
    """
    
    func convertDataFile(data: Data, showHiddenFiles: Bool) -> [NCFile] {
        
        var files = [NCFile]()
        let webDavRoot = "/" + NCCommunicationCommon.sharedInstance.webDavRoot + "/"
        let davRootFiles = "/" + NCCommunicationCommon.sharedInstance.davRoot + "/files/"
        guard let baseUrl = NCCommunicationCommon.sharedInstance.getHostName(urlString: NCCommunicationCommon.sharedInstance.url) else {
            return files
        }
        
        let xml = XML.parse(data)
        let elements = xml["d:multistatus", "d:response"]
        for element in elements {
            let file = NCFile()
            if let href = element["d:href"].text {
                var fileNamePath = href
                
                if href.last == "/" {
                    fileNamePath = String(href.dropLast())
                }
                
                // path
                file.path = (fileNamePath as NSString).deletingLastPathComponent + "/"
                file.path = file.path.removingPercentEncoding ?? ""
                
                // fileName
                file.fileName = (fileNamePath as NSString).lastPathComponent
                file.fileName = file.fileName.removingPercentEncoding ?? ""
                if file.fileName.first == "." && !showHiddenFiles { continue }
              
                // ServerUrl
                if href.hasSuffix(webDavRoot) {
                    file.fileName = "."
                    file.serverUrl = ".."
                } else if file.path.contains(webDavRoot) {
                    file.serverUrl = baseUrl + file.path.dropLast()
                } else if file.path.contains(davRootFiles + NCCommunicationCommon.sharedInstance.user) {
                    let postUrl = file.path.replacingOccurrences(of: davRootFiles + NCCommunicationCommon.sharedInstance.user, with: webDavRoot.dropLast())
                    file.serverUrl = baseUrl + postUrl.dropLast()
                }
                file.serverUrl = file.serverUrl.removingPercentEncoding ?? ""
            }
            
            let propstat = element["d:propstat"][0]
                        
            if let getlastmodified = propstat["d:prop", "d:getlastmodified"].text {
                if let date = NCCommunicationCommon.sharedInstance.convertDate(getlastmodified, format: "EEE, dd MMM y HH:mm:ss zzz") {
                    file.date = date
                }
            }
            
            if let creationdate = propstat["d:prop", "d:creationdate"].text {
                if let date = NCCommunicationCommon.sharedInstance.convertDate(creationdate, format: "EEE, dd MMM y HH:mm:ss zzz") {
                    file.creationDate = date
                }
            }
            
            if let getetag = propstat["d:prop", "d:getetag"].text {
                file.etag = getetag.replacingOccurrences(of: "\"", with: "")
            }
            
            if let getcontenttype = propstat["d:prop", "d:getcontenttype"].text {
                file.contentType = getcontenttype
            }
            
            let resourcetypeElement = propstat["d:prop", "d:resourcetype"]
            if resourcetypeElement["d:collection"].error == nil {
                file.directory = true
                file.contentType = "application/directory"
            } else {
                if let resourcetype = propstat["d:prop", "d:resourcetype"].text {
                    file.resourceType = resourcetype
                }
            }
            
            if let quotaavailablebytes = propstat["d:prop", "d:quota-available-bytes"].text {
                file.quotaAvailableBytes = Double(quotaavailablebytes) ?? 0
            }
            
            if let quotausedbytes = propstat["d:prop", "d:quota-used-bytes"].text {
                file.quotaUsedBytes = Double(quotausedbytes) ?? 0
            }
                       
            if let permissions = propstat["d:prop", "oc:permissions"].text {
                file.permissions = permissions
            }
            
            if let ocId = propstat["d:prop", "oc:id"].text {
                file.ocId = ocId
            }
            
            if let fileId = propstat["d:prop", "oc:fileid"].text {
                file.fileId = fileId
            }
            
            if let size = propstat["d:prop", "oc:size"].text {
                file.size = Double(size) ?? 0
            }
            
            if let favorite = propstat["d:prop", "oc:favorite"].text {
                file.favorite = (favorite as NSString).boolValue
            }
            
            if let ownerid = propstat["d:prop", "oc:owner-id"].text {
                file.ownerId = ownerid
            }
            
            if let ownerdisplayname = propstat["d:prop", "oc:owner-display-name"].text {
                file.ownerDisplayName = ownerdisplayname
            }
            
            if let commentsunread = propstat["d:prop", "oc:comments-unread"].text {
                file.commentsUnread = (commentsunread as NSString).boolValue
            }
                        
            if let encrypted = propstat["d:prop", "nc:is-encrypted"].text {
                file.e2eEncrypted = (encrypted as NSString).boolValue
            }
            
            if let haspreview = propstat["d:prop", "nc:has-preview"].text {
                file.hasPreview = (haspreview as NSString).boolValue
            }
            
            if let mounttype = propstat["d:prop", "nc:mount-type"].text {
                file.mountType = mounttype
            }
            
            if let richWorkspace = propstat["d:prop", "nc:rich-workspace"].text {
                file.richWorkspace = richWorkspace
            }
            
            // UTI
            if let unmanagedFileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (file.fileName as NSString).pathExtension as CFString, nil) {
                let fileUTI = unmanagedFileUTI.takeRetainedValue()
                let ext = (file.fileName as NSString).pathExtension.lowercased()
                
                // contentType detect
                if file.contentType == "" {
                    if let mimeUTI = UTTypeCopyPreferredTagWithClass(fileUTI, kUTTagClassMIMEType) {
                        file.contentType = mimeUTI.takeRetainedValue() as String
                    }
                }
                
                if file.directory {
                    file.typeFile = typeFile.directory.rawValue
                    file.iconName = iconName.directory.rawValue
                } else if UTTypeConformsTo(fileUTI, kUTTypeImage) {
                    file.typeFile = typeFile.image.rawValue
                    file.iconName = iconName.image.rawValue
                } else if UTTypeConformsTo(fileUTI, kUTTypeMovie) {
                    file.typeFile = typeFile.video.rawValue
                    file.iconName = iconName.movie.rawValue
                } else if UTTypeConformsTo(fileUTI, kUTTypeAudio) {
                    file.typeFile = typeFile.audio.rawValue
                    file.iconName = iconName.audio.rawValue
                } else if UTTypeConformsTo(fileUTI, kUTTypeContent) {
                    file.typeFile = typeFile.document.rawValue
                    if fileUTI as String == "com.adobe.pdf" {
                        file.iconName = iconName.pdf.rawValue
                    } else if fileUTI as String == "org.openxmlformats.wordprocessingml.document" || fileUTI as String == "com.microsoft.word.doc" {
                        file.iconName = iconName.document.rawValue
                    } else if fileUTI as String == "org.openxmlformats.spreadsheetml.sheet" || fileUTI as String == "com.microsoft.excel.xls" {
                        file.iconName = iconName.xls.rawValue
                    } else if fileUTI as String == "org.openxmlformats.presentationml.presentation" || fileUTI as String == "com.microsoft.powerpoint.ppt" {
                        file.iconName = iconName.ppt.rawValue
                    } else if fileUTI as String == "public.plain-text" {
                        file.iconName = iconName.txt.rawValue
                    } else if fileUTI as String == "public.html" {
                        file.iconName = iconName.code.rawValue
                    } else {
                        file.iconName = iconName.document.rawValue
                    }
                } else if UTTypeConformsTo(fileUTI, kUTTypeZipArchive) {
                    file.typeFile = typeFile.compress.rawValue
                    file.iconName = iconName.compress.rawValue
                } else if ext == "imi" {
                    file.typeFile = typeFile.imagemeter.rawValue
                    file.iconName = iconName.imagemeter.rawValue
                } else {
                    file.typeFile = typeFile.unknow.rawValue
                    file.iconName = iconName.unknow.rawValue
                }
            }
            
            files.append(file)
        }
        
        return files
    }
}

