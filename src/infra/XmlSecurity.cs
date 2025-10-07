using System;
using System.Security.Cryptography.Xml;
using System.Xml;

namespace Infra.Security.Xml
{
    public class SignedXmlWithId : SignedXml
    {
        private const string WsUtilityNs =
            "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd";

        public SignedXmlWithId(XmlDocument xml) : base(xml) { }
        public SignedXmlWithId(XmlElement element) : base(element) { }

        public override XmlElement GetIdElement(XmlDocument document, string idValue)
        {
            var idElem = base.GetIdElement(document, idValue);
            if (idElem != null) return idElem;

            var nsManager = new XmlNamespaceManager(document.NameTable);
            nsManager.AddNamespace("wsu", WsUtilityNs);

            return document.SelectSingleNode("//*[@wsu:Id='" + idValue + "']", nsManager) as XmlElement;
        }
    }

    public class SamlXmlHelper
    {
        private readonly XmlDocument _doc;
        private readonly XmlNamespaceManager _ns;

        public SamlXmlHelper(XmlDocument doc)
        {
            _doc = doc;
            _ns = new XmlNamespaceManager(doc.NameTable);
            _ns.AddNamespace("ds", "http://www.w3.org/2000/09/xmldsig#");
            _ns.AddNamespace("saml", "urn:oasis:names:tc:SAML:2.0:assertion");
            _ns.AddNamespace("xenc", "http://www.w3.org/2001/04/xmlenc#");
        }

        public XmlElement ResolveByAttribute(string referenceAttributeId, string idValue)
        {
            return (XmlElement)_doc.SelectSingleNode(
                string.Format("//*[@{0}='{1}']", referenceAttributeId, idValue)
            );
        }

        public XmlNode GetNode(string xpath)
        {
            return _doc.SelectSingleNode(xpath, _ns);
        }
    }
}
